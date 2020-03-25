RSpec.describe Helpers::Factories do
  describe ".file_name_has_error?" do
    context "when the file name is not pluralized" do
      context "and the file name is multiple words" do
        let(:file_name) { "user_billing" }

        it "returns true" do
          expect(described_class.file_name_has_error?(file_name)).to eq(true)
        end
      end

      context "and the file name is one word" do
        let(:file_name) { "billing" }

        it "returns true" do
          expect(described_class.file_name_has_error?(file_name)).to eq(true)
        end
      end
    end

    context "when the file name is pluralized" do
      context "and the file name is multiple words" do
        let(:file_name) { "user_billings" }

        it "returns true" do
          expect(described_class.file_name_has_error?(file_name)).to eq(false)
        end
      end

      context "and the file name is one word" do
        let(:file_name) { "data" }

        it "returns true" do
          expect(described_class.file_name_has_error?(file_name)).to eq(false)
        end
      end
    end
  end
end
