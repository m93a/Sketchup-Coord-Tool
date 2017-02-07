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

		def self.to_cylindrical(center,raxis,zaxis,scale=1)
			taxis = zaxis.cross(raxis)
			model = Sketchup.active_model
			original_axes = [model.axes.origin, *model.axes.axes]
			model.axes.set(center,raxis,taxis,zaxis)

			vertices = []
			entities = model.active_entities

			entities.each{ |e|
				puts e
				if e.is_a? Sketchup::Edge
					vertices.push *e.vertices
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
				pos.set! pos.distance([0,0,0]),
								 Math.tan(pos.y/pos.x),
								 pos.z
			 pos.transform!(t2)

			 # there's no such thing as
			 # v.position = pos
			 # equivalent:
			 entities.transform_by_vectors(
			 	[v], [v.position.vector_to(pos)]
			 )

			}
		end

		def self.activate_cylindrical_tool
			Sketchup.active_model.select_tool(Cylindrical_Tool.new)
		end

	end #module

end #module
