RSpec.describe RootCops::NoTracers do
  subject(:cop) { described_class.new }

  ["Tracer.trace_method", "Tracer.any_method"].each do |offending_form|
    it_behaves_like "registers an offense", offending_form, described_class::MSG
  end
end
