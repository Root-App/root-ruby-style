module RuboCop
  module Cop
    module RootCops
      class JobHasQueue < RuboCop::Cop::Base
        MESSAGE = "Configure the job to run in a specific queue using queue_as, sharded_queue_as or a whitelisted mixin.".freeze
        MIXIN_ALLOW_LIST = %i[LookupQueueConcern NewBusinessQuoteCreationQueueConcern PricingBackfillQueueConcern RatesQueueConcern MonitoringConcern].freeze
        QUEUEING_OPTIONS = %i[queue_as sharded_queue_as].freeze

        def on_class(node)
          class_name = node.to_a[0].to_a[1]
          return unless class_name.to_s.end_with?("Job")

          send_descendants = node.descendants.select(&:send_type?)
          unless send_descendants.any? { |d| QUEUEING_OPTIONS.include?(d.to_a[1]) || _whitelisted_mixin?(d) }
            add_offense(node.loc.expression, message: MESSAGE)
          end
        end

        private

        def _whitelisted_mixin?(descendant)
          descendant.to_a[1] == :include && MIXIN_ALLOW_LIST.include?(descendant.to_a[2].to_a[1])
        end
      end
    end
  end
end
