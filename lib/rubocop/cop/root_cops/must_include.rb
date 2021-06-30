module RuboCop
  module Cop
    module RootCops
      # Classes in this directory must include a specific module
      #
      # @example
      #
      # Given the following config:
      # RootCops/MustInclude:
      #   Mapping:
      #     - Dir: engines/claims/app/jobs/
      #       Module: ClaimsJobConcern
      #
      #   # bad
      #   class BackfillClaimJob < ResqueJob
      #   end
      #
      #   # good
      #   class BackfillClaimJob < ResqueJob
      #     include ClaimsJobConcern
      #   end

      class MustInclude < Cop
        # entirely so i can stub this in the tests
        def self.expand_path(filename)
          File.expand_path(filename)
        end

        def investigate(processed_source)
          @source_file_path = self.class.expand_path(processed_source.buffer.name)
          @module_to_include = module_to_include_for_current_file
          @proper_module_is_included = false
          @class_node = nil
        end

        def investigate_post_walk(_processed_source)
          if search_for_inclusion? && !@proper_module_is_included
            add_offense(@class_node, :location => :expression, :message => "Classes in this directory must include #{@module_to_include} module")
          end
        end

        def search_for_inclusion?
          @module_to_include && @class_node
        end

        def_node_matcher :find_module_inclusion, <<~PATTERN
          (send nil? :include
              (const _ $_module_name))
        PATTERN

        def on_class(node)
          return unless @module_to_include
          @class_node = node
        end

        def on_send(node)
          return unless search_for_inclusion? && !@proper_module_is_included

          find_module_inclusion(node) do |module_name|
            @proper_module_is_included ||= module_name.to_s == @module_to_include
          end
        end

        def mapping
          @mapping ||= (cop_config["Mapping"] || []).map do |config|
            {
              :glob => File.join("**", config["Dir"], "*.rb"),
              :module => config["Module"]
            }
          end
        end

        def module_to_include_for_current_file
          mapping.detect { |m| File.fnmatch?(m[:glob], @source_file_path) }&.fetch(:module)
        end
      end
    end
  end
end
