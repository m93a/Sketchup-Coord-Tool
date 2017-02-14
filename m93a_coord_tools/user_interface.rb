=begin

Coordinate Tools
Copyright 2017, m93a
Published under the MIT License

See loader file for detailed information

=end

require 'sketchup.rb'
require 'm93a_coord_tools/functions.rb'


module M93A

	module Coord_Tools

		def self.getTb
			puts tb
		end

		if !file_loaded?(__FILE__)

      # Create the toolbar object we will be using
			tb = UI::Toolbar.new("Coordinate Tools")


			# See the SU Ruby API docs for more information on creating
      # toolbars and menu commands.
			to_cylindrical = UI::Command.new("Unwrap Cylinder") {
				self.activate_tool_unwrap
			}
      to_cylindrical.small_icon = "Images/cylinder_cube_16.png"
      to_cylindrical.large_icon = "Images/cylinder_cube_24.png"
      to_cylindrical.tooltip = "Unwrap Cylinder"
      to_cylindrical.status_bar_text = "Convert Cartesian coordinates to cylindrical"
      to_cylindrical.menu_text = "Unwrap Cylinder"
      tb.add_item(to_cylindrical)

			from_cylindrical = UI::Command.new("Wrap Cylinder") {
				self.activate_tool_wrap
			}
      from_cylindrical.small_icon = "Images/cube_cylinder_16.png"
      from_cylindrical.large_icon = "Images/cube_cylinder_24.png"
      from_cylindrical.tooltip = "Wrap Cylinder"
      from_cylindrical.status_bar_text = "Convert cylindrical coordinates to Cartesian"
      from_cylindrical.menu_text = "Wrap Cylinder"
      tb.add_item(from_cylindrical)

      # Show the toolbar. If it was shown last time the user had it on, then
      # turn it on.  If it was off last time the user used SU,
      # then leave it off.

      unless tb.get_last_state == TB_HIDDEN
        tb.restore
        UI.start_timer( 0.1, false ) { tb.restore } # SU bug 2902434
      end


      # This tells SU that the file is loaded into the menu system
			file_loaded(__FILE__)
		end

	end #module

end #module
