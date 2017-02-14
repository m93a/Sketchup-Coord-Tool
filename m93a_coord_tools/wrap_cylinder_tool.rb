=begin

Coordinate Tools
Copyright 2017, m93a
Published under the MIT License

See loader file for detailed information

=end

module M93A

  module Coord_Tools

    class Wrap_Cylinder_Tool


      def activate
        @minus = Sketchup::InputPoint.new
        @plus  = Sketchup::InputPoint.new
        @last  = Sketchup::InputPoint.new

        update_ui
      end

      def reset_tool
        @minus.clear
        @plus.clear
        @last.clear

        update_ui
      end

      def update_ui
        if ! @minus.valid?
          Sketchup.status_text = "Select the minimum on the pole-line, where theta=−π. Usually the left one."
        elsif ! @plus.valid?
          Sketchup.status_text = "Select the maximum on the pole-line, where theta=π. Try that one on the right."
        else
          Sketchup.status_text = "Select a reference point on the model."
        end
      end

      def draw(v)
        @minus.draw(v) if @minus.valid?
        @plus .draw(v) if @plus .valid?
        @last .draw(v) if @last .valid?
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
        if (! @minus.valid? or @plus.valid?)
          @last.pick(v,x,y)
        else
          @last.pick(v,x,y,@minus)
        end

        v.tooltip = @last.tooltip if @last.valid?
        v.invalidate
        update_ui
      end

      def onLButtonDown(flags, x, y, v)
        if ! @minus.valid?
          @minus.copy! @last
        elsif ! @plus.valid?
          @plus.copy! @last
        else
          model = Sketchup.active_model
          a = @minus.position
          b = @plus.position
          r = @last.position

          theta = a.vector_to(b)
          scale = theta.length
          theta.normalize!
          center = a.offset(theta, scale/2)

          scale /= 2*Math::PI
          ref = a.vector_to(r)
          zaxis = theta.cross(ref)

          if zaxis.length != 0
            zaxis.normalize!
          else
            zaxis=Geom::Vector3d.new 0,0,1
          end

          ents = model.active_entities

          anim = Coord_Tools.from_cylindrical(ents,center,theta,zaxis,scale)
          # v.animation = Vertex_Animation.new(1000,*anim)

          reset_tool
        end

        update_ui
      end

    end # Cylindrical_Tool

  end # Coord_Tools

end # M93A
