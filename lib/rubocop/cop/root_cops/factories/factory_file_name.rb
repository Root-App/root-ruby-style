require "active_support/inflector"
require_relative "../../../helpers/factories"

module RuboCop
  module Cop
    module RootCops
      module Factories
        class FactoryFileName < RuboCop::Cop::Base
          def on_new_investigation
            file_path = processed_source.buffer.name
            @base_file_name = File.basename(file_path, ".rb")
            @base_file_name_last_word = @base_file_name.split("_").last
          end

          def on_send(node)
            receiver, method_name = *node
            _, receiver_name = *receiver

            if receiver_name == :FactoryBot && method_name == :define && Helpers::Factories.file_name_has_error?(@base_file_name)
              add_offense(
                node.loc.expression,
                severity: :fatal,
                message: "Factory file name should be plural (#{@base_file_name.pluralize})."
              )
            end
          end
        end
      end
    end
  end
end
