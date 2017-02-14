=begin

Coordinate Tools
Copyright 2017, m93a
Published under the MIT License

See loader file for detailed information

=end

#require "m93a_coord_tools/animation.rb"

module M93A

  module Coord_Tools

    class Unwrap_Cylinder_Tool


      def activate
        @center = Sketchup::InputPoint.new
        @zero  = Sketchup::InputPoint.new
        @last  = Sketchup::InputPoint.new

        update_ui
      end

      def reset_tool
        @center.clear
        @zero.clear
        @last.clear

        update_ui
      end

      def update_ui
        if ! @center.valid?
          Sketchup.status_text = "Select the pole (the center of your cone)"
        elsif ! @zero.valid?
          Sketchup.status_text = "Select the r axis. This will be the theta=0 line."
        else
          Sketchup.status_text = "Select the reference point."
        end
      end

      def draw(v)
        @center.draw(v) if @center.valid?
        @zero  .draw(v) if @zero  .valid?
        @last  .draw(v) if @last  .valid?
      end

      def onSetCursor
        # FIXME
        UI.set_cursor 632
      end

      def deactivate(v)
        v.invalidate
      end

      def resume(v)
        update_ui
        v.invalidate
      end

      def onCancel(reason, v)
        #reason==2 if Ctrl+Z
        reset_tool
        v.invalidate
      end

      def onMouseMove(flags, x, y, v)
        if ! @center.valid?
          @last.pick(v,x,y)
        else
          @last.pick(v,x,y,@center)
        end

        v.tooltip = @last.tooltip if @last.valid?
        v.invalidate
        update_ui
      end

      def onLButtonDown(flags, x, y, v)
        if ! @center.valid?
          @center.copy! @last
        elsif ! @zero.valid?
          @zero.copy! @last
        else
          model = Sketchup.active_model
          c = @center.position
          r = @zero.position
          s = @last.position

          raxis = c.vector_to(r).normalize!
          s_vec = c.vector_to(s)
          zaxis = raxis.cross(s_vec)

          if zaxis.length != 0
            zaxis.normalize!
          else
            zaxis=Geom::Vector3d.new 0,0,1
          end

          a_len = r.vector_to(s).length
          scale = a_len / raxis.angle_between(s_vec)

          ents = model.active_entities

          anim = Coord_Tools.to_cylindrical(ents,c,raxis,zaxis,scale)
          # v.animation = Vertex_Animation.new(1000,*anim)

          reset_tool
        end

        update_ui
      end

    end # Cylindrical_Tool

  end # Coord_Tools

end # M93A
