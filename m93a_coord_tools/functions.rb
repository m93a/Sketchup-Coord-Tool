=begin

Coordinate Tools
Copyright 2017, m93a
Published under the MIT License

See loader file for detailed information

=end

require "m93a_coord_tools/cylindrical_tool.rb"


module M93A

	module Coord_Tools

		def self.su_select_all
			model = Sketchup.active_model
			sel = model.selection
			ents = model.active_entities
			sel.add( ents.to_a )
		end

		def self.msgbox(msg)
			UI.messagebox( msg )
		end

		# convert Cartesian coords to cylindrical
		def self.to_cylindrical(entities,center,raxis,zaxis,scale=1)
			model = Sketchup.active_model

			model.start_operation('Coordinate conversion', true)
			taxis = zaxis.cross(raxis)
			original_axes = [model.axes.origin, *model.axes.axes]
			original_axes = original_axes.map { |e| e.clone  }
			model.axes.set(center,raxis,taxis,zaxis)

			t2 = model.axes.transformation
			t1 = t2.inverse

			vertices = []
			vectors  = []

			curves = []

			pi = Math::PI


			proc {
				# Extract instances of Vertex from the
				# entities. Curves are exploded because
				# there's a bug with regular polygons and
				# arcs, which results in a distorted model.
				# see: https://forums.sketchup.com/t/38771

				entities.each{ |e|
					if e.is_a? Sketchup::Edge
						if e.curve
							curves.push e.curve.vertices
							vertices.push *e.explode_curve.vertices
						else
						  vertices.push *e.vertices
						end
					elsif e.is_a? Sketchup::ConstructionPoint
						vertices.push e
					end
				}

				vertices.uniq!

			}.call



			proc {
				# When unwraping a cylinder, there has
				# to be a cut. This part makes sure that
				# there always exist vertices on the cut,
				# not just edges.

				z_max = z_min = x_min = 0

				vertices.each { |v|
					pos = v.position.clone
					pos.transform!(t1)

					z_max = pos.z if pos.z > z_max
					z_min = pos.z if pos.z < z_min
					x_min = pos.x if pos.x < x_min
				}

				face_vertices = [
					[  0,   0, z_min], [x_min, 0, z_min],
					[x_min, 0, z_max], [  0,   0, z_max]
				]

				face_vertices.map! { |pos|
					pos.transform(t2)
				}

				# add the cutting face into a group so
				# that removing it doesn't cause trouble
				face_group = entities.add_group
				face_ents = face_group.entities

				# add_face fails on planar selection
				begin
					face_ents.add_face(face_vertices)
				rescue
					face_ents.add_edges(*face_vertices)
				end

				face = face_ents.to_a

				intersections = entities.add_group
				dummy_trasformation = Geom::Transformation.new

				entities.intersect_with(
					false, # TODO change this when groups are implemented
					dummy_trasformation,
					intersections.entities,
					dummy_trasformation,
					true, # use hidden geometry
					face
				)

				entities.erase_entities(face_group)

				# add new vertices to the array
				inter_entities = intersections.explode
				inter_vertices = []

				if(inter_entities)
					inter_entities.each{ |e|
						if e.is_a? Sketchup::Vertex
						then inter_vertices.push e end
					}
					inter_vertices.uniq!
					vertices.push *inter_vertices
				end

			}.call



			proc {
				# This part performs the transformation.
				# It also treats the vertices in singularities
				# with special care (not implemented yet).

				faces_to_create = []

				vertices_add = []
				vertices_del = []
				vectors_add  = []
				vectors_del  = []

				v_alter = nil
				pos_alter = nil

				vertices.each { |v|
					pos = v.position.clone
					pos.transform!(t1)

					v_alter = nil
					pos_alter = nil

					if pos.y == 0 && pos.x <= 0
						if pos.x == 0
							# on pole
						else
							# on cutting plane

							vpos_alter = Geom::Point3d.new [pos.x, -100, pos.z]
							vpos_alter.transform! t2

							v.faces.each { |f|
								# TODO
							}

							v.edges.each { |e|

								v2 = e.other_vertex v
								v2t = v2.position.transform t1
								if v2t.y <= 0
									entities.erase_entities e if v2t.y < 0

									line = entities.add_line(
										v2.position, vpos_alter )

									v_alter = line.other_vertex v2
								end
							}

							pos       = [-pos.x, pi*scale, pos.z ]
							pos_alter = [pos.x,-pi*scale, pos.z ]
							pos_alter.transform! t2

						end
					else

						# ordinary point

						r = Math.sqrt(pos.x**2+pos.y**2)
						t = Math.atan2(pos.y,pos.x) * scale
						z = pos.z

						pos.set! r,t,z
					end

					pos.transform!(t2)

					# make list of transformations so
					# that they can be interpolated
					vectors.push v.position.vector_to(pos)

					if(v_alter)
						vertices_add.push v_alter
						vectors_add.push v_alter.position.vector_to(pos_alter)
					end
				}

				vertices.push *vertices_add
				vectors.push  *vectors_add

				entities.transform_by_vectors(vertices, vectors)

			}.call


			# add the "pole-line"
			pole1 = Geom::Point3d.new 0, -pi*scale, 0
			pole2 = Geom::Point3d.new 0,  pi*scale, 0
			pole1.transform! t2
			pole2.transform! t2
			entities.add_line pole1, pole2

			# reweld the curves
			curves.each{ |c|
				entities.add_curve(c)
			}

			# reset axes and commit
			model.axes.set *original_axes
			model.commit_operation

			[vertices, vectors]
		end

		def self.activate_cylindrical_tool
			Sketchup.active_model.select_tool(Cylindrical_Tool.new)
		end

	end #module

end #module
