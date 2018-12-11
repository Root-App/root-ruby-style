module RuboCop
  module Cop
    module RootCops
      class SpecFileName < Cop
        FILE_NAME_ERROR = "Specs should be in files ending in _spec.rb".freeze

        def investigate(processed_source)
          @file_path = processed_source.buffer.name
        end

        def on_send(node)
          receiver, method_name = *node
          _, receiver_name = *receiver
          return unless receiver_name == :RSpec && method_name == :describe

          unless @file_path.end_with?("_spec.rb")
            add_offense(node, :location => :expression, :message => FILE_NAME_ERROR)
          end
        end
      end
    end
  end
end
