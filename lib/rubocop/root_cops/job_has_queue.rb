module RootCops
  class JobHasQueue < ::RuboCop::Cop::Cop
    MESSAGE = "Configure the job to run in a specific queue using queue_as.".freeze

    def on_class(node)
      class_name = node.to_a[0].to_a[1]
      return unless class_name.to_s.end_with?("Job")
      send_descendants = node.descendants.select(&:send_type?)
      unless send_descendants.any? { |d| d.to_a[1] == :queue_as }
        add_offense(node, :expression, MESSAGE)
      end
    end
  end
end
