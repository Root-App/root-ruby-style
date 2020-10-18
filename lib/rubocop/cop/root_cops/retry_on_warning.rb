module RuboCop
  module Cop
    module RootCops
      # define `before_retry` when using `retry_on`
      #
      # @example
      #   # bad
      #   class RetryableJob
      #     retry_on StandardError
      #     def perform(customer_id:)
      #       Charge_customer(customer_id)
      #     end
      #   end
      #
      #   # good
      #   class RetryableJob
      #     retry_on StandardError
      #     def perform(customer_id:)
      #       charge_customer(customer_id)
      #     end
      #     def before_retry(customer_id:)
      #       raise if already_charged(customer_id)
      #     end
      #   end

      class RetryOnWarning < Cop
        MSG = %(When using "retry_on", ensure the job is idempotent and define a 'before_retry' to handle side effects or preconditions. NOTE: Jobs running on SQS cannot wait longer than 15 minutes for retry.).freeze

        def on_class(node)
          class_name = node.to_a[0].to_a[1]
          return unless class_name.to_s.end_with?("Job")

          if _includes_retry_on?(node) && (_missing_before_retry?(node) || _retry_args_mismatch?(node))
            add_offense(node, :location => :expression, :message => MSG)
          end
        end

        private

        def _includes_retry_on?(node)
          send_descendants = node.descendants.select(&:send_type?)
          send_descendants.any? { |d| d.to_a[1] == :retry_on }
        end

        def _missing_before_retry?(node)
          begin_descendants = node.descendants.select(&:begin_type?)
          begin_descendants.none? { |d| d.to_a[0] == :before_retry }
        end

        def _retry_args_mismatch?(node)
          begin_descendants = node.descendants.select(&:begin_type?)
          perform_def = begin_descendants.detect? { |d| d.to_a[0] == :perform }
          retry_def = begin_descendants.detect? { |d| d.to_a[0] == :before_retry }

          retry_def.to_a[1] != perform_def.to_a[1]
        end
      end
    end
  end
end
