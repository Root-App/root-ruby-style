require "yaml"

RSpec.describe ".rubocop.yml" do
  it "includes all of our cops", :aggregate_failures do
    config_location = File.expand_path("../../.rubocop.yml", File.dirname(__FILE__))
    rubocop_config = YAML.load_file(config_location)
    required_libs = rubocop_config["require"].map { |lib| lib.sub("\./", "") }

    cops_location = File.expand_path("../../lib/rubocop/cop/root_cops", File.dirname(__FILE__))
    Dir.glob("#{cops_location}/**/*") do |cop_file|
      next unless File.file?(cop_file)

      cop_file_required = required_libs.any? { |lib| cop_file.end_with?(lib) }
      expect(cop_file_required).to be(true), "Expected #{cop_file} to be included in project's .rubocop.yml config"
    end
  end
end
