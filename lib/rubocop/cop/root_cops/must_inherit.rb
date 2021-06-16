module RuboCop
  module Cop
    module RootCops
      # Classes in this directory must inherit from a specific class
      #
      # @example
      #
      # Given the following config:
      # RootCops/MustInherit:
      #   Mapping:
      #     - Dir: engines/claims/app/jobs/
      #       ParentClass: ClaimsJob
      #
      #   # bad
      #   class BackfillClaimJob < ApplicationJob # ...
      #
      #   # good
      #   class BackfillClaimJob < ClaimsJob # ...

      class MustInherit < Cop
        # entirely so i can stub this in the tests
        def self.expand_path(filename)
          File.expand_path(filename)
        end

        def investigate(processed_source)
          @source_file_path = self.class.expand_path(processed_source.buffer.name)
        end

        def_node_matcher :find_class_inheritance, <<~PATTERN
          (class
           (const _ $_child)
           {(const _ $_parent) $_noparent}
           _)
        PATTERN

        def on_class(node)
          return unless (config_superclass_name = parent_class_for_current_file)

          find_class_inheritance(node) do |class_name, superclass_name|
            if class_name.to_s != config_superclass_name && superclass_name.to_s != config_superclass_name
              add_offense(node, :location => :expression, :message => "Classes in this directory must inherit from #{config_superclass_name}")
            end
          end
        end

        def mapping
          @mapping ||= (cop_config["Mapping"] || []).map do |config|
            {
              :glob => File.join("**", config["Dir"], "*.rb"),
              :parent_class => config["ParentClass"]
            }
          end
        end

        def parent_class_for_current_file
          mapping.detect { |m| File.fnmatch?(m[:glob], @source_file_path) }&.fetch(:parent_class)
        end
      end
    end
  end
end
