=begin

Coordinate Tools
Copyright 2017, m93a
Published under the MIT License

See loader file for detailed information

=end


module M93A

	module Coord_Tools

		def self.su_select_all
			model = Sketchup.active_model
			sel = model.selection
			ents = model.active_entities
			sel.add( ents.to_a )
		end # main

		def self.msgbox(msg)
			UI.messagebox( msg )
		end

	end #module

end #module
