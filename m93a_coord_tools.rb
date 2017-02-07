=begin

Coordinate Tools
Copyright 2017, m93a
Published under the MIT License


Description:
This extension is capable of transforming the model (or more precisely
the active selection) from the Cartesian coordinates into cylindrical
or spherical coordinates and maping them back to X, Y and Z. This way
you can eg. create spiral staircase using just the push/pull tool.

Usage:
/* TODO */
Access the extension from the menu "Plugins > Extension Warehouse Template".
Developers are encouraged to use this script to learn the basics of how to
create an extension that is compatible with the Extension Warehouse.


License
Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the Software
is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

=end


module M93A # Hope more extensions will soon follow ;)

	module Coord_Tools

		require 'sketchup.rb'
		require 'extensions.rb'
		require 'langhandler.rb'

		m93a_coord_tools = SketchupExtension.new(
      "Coordinate Tools",
      "m93a_coord_tools/user_interface.rb")


		m93a_coord_tools.name = "Coordinate Tools"
		m93a_coord_tools.version = '0.0.0'

		m93a_coord_tools.description = "This extension is capable of "+
		"transforming the model from the Cartesian coordinates into "+
		"cylindrical or spherical coordinates."

		m93a_coord_tools.creator = "m93a (Michal Grňo)"
		m93a_coord_tools.copyright = "2017"

		Sketchup.register_extension( m93a_coord_tools, true )


	end # Coord_Tools

end # M93A
