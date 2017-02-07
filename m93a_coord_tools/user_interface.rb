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

      # Add a submenu to the "Plugins" menu.
			menu = UI.menu("Plugins").add_submenu("Coordinate Tools")
      # Create the toolbar object we will be using
			tb = UI::Toolbar.new("Coordinate Tools")


			# See the SU Ruby API docs for more information on creating
      # toolbars and menu commands.
      select_all = UI::Command.new("Select All") { su_select_all }
      select_all.small_icon = "Images/icon1_16.png"
      select_all.large_icon = "Images/icon1_24.png"
      select_all.tooltip = "Select All"
      select_all.status_bar_text = "Select everything"
      select_all.menu_text = "Select All"
      menu.add_item(select_all)
      tb.add_item(select_all)


			command2 = UI::Command.new("Message Box") { msgbox("Messagebox 1") }
      command2.small_icon = "Images/icon2_16.png"
      command2.large_icon = "Images/icon2_24.png"
      command2.tooltip = "Message Box"
      command2.tooltip = "Message Box"
      command2.status_bar_text = "Pop up a simple messagebox"
      command2.menu_text = "Message Box"
      menu.add_item(command2)
      tb.add_item(command2)


      command3 = UI::Command.new("To Cylindrical Coordinates") {
				self.activate_cylindrical_tool
			}
      command3.small_icon = "Images/icon3_16.png"
      command3.large_icon = "Images/icon3_24.png"
      command3.tooltip = "Message Box 2"
      command3.status_bar_text = "Pop up a second simple messagebox"
      command3.menu_text = "Message Box 2"
      menu.add_item(command3)
      tb.add_item(command3)

      # Show the toolbar. If it was shown last time the user had it on, then
      # turn it on.  If it was off last time the user used SU,
      # then leave it off.
=begin
      unless tb.get_last_state == TB_HIDDEN
        tb.restore
        UI.start_timer( 0.1, false ) { tb.restore } # SU bug 2902434
      end
=end

      # This tells SU that the file is loaded into the menu system
			file_loaded(__FILE__)
		end

	end #module

end #module
