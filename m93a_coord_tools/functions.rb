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

		def self.to_cylindrical(entities,center,raxis,zaxis,scale=1)
			model = Sketchup.active_model

			model.start_operation('Coordinate conversion', true)
			taxis = zaxis.cross(raxis)
			original_axes = [model.axes.origin, *model.axes.axes]
			model.axes.set(center,raxis,taxis,zaxis)

			vertices = []
			vectors = []

			entities.each{ |e|
				if e.is_a? Sketchup::Edge
					if e.curve
						vertices.push *e.explode_curve.vertices
					else
					  vertices.push *e.vertices
					end
				elsif e.is_a? Sketchup::ConstructionPoint
					vertices.push e
				end
			}

			vertices.uniq!

			t2 = model.axes.transformation
			t1 = t2.inverse

			vertices.each { |v|
				pos = v.position.clone
				pos.transform!(t1)

				r = Math.sqrt(pos.x**2+pos.y**2)
				t = Math.atan2(pos.y,pos.x) * scale
				t += Math::PI if t<0
				z = pos.z

				pos.set! r,t,z
			 pos.transform!(t2)

			 # make list of transformations
			 # so that they can interpolate
			 vectors.push v.position.vector_to(pos)
			}

			entities.transform_by_vectors(vertices, vectors)

			model.axes.set *original_axes
			model.commit_operation

			[vertices, vectors]
		end

		def self.activate_cylindrical_tool
			Sketchup.active_model.select_tool(Cylindrical_Tool.new)
		end

	end #module

end #module
