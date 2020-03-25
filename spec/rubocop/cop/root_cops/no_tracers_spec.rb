RSpec.describe RootCops::NoTracers do
  OFFENDING_FORMS = [
    "Tracer.trace_method".freeze,
    "Tracer.any_method".freeze
  ].freeze

  subject(:cop) { described_class.new }

  OFFENDING_FORMS.each do |offending_form|
    it_behaves_like "registers an offense", offending_form, described_class::MSG
  end
end
