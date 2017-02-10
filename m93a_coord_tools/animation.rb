=begin

Coordinate Tools
Copyright 2017, m93a
Published under the MIT License

See loader file for detailed information

=end

module M93A

  module Coord_Tools

    class Vertex_Animation

      # FIXME These animations do not work!

      def initialize( time, vertices, vectors )
        @start = Time.now.to_i
        @end = @start + time

        @vtx = vertices
        @vec = vectors

        @progress = 0

        @model = Sketchup.active_model
        @model.start_operation("Animation")
        @model.active_entities.transform_by_vectors(
          @vtx, @vec.map {|v| v.reverse }
        )

      end

      def nextFrame(v)
        progress = (Time.now.to_i-@start)/(@end-@start)

        if progress >= 1
          @model.abort_operation
          return false
        end

        @model.active_entities.transform_by_vectors(
          @vtx, @vec.map {
            |v| v.clone.set! v.to_a.map {
              |x|  x*(progress - @progress)
            }
          }
        )
        @progress = progress
      end

      def stop
        @model.abort_operation
      end

    end # Vertex_Animation

  end # Coord_Tools

end # M93A
