require "spec_helper"

describe RecurlyEvent::Namespace do
  subject { described_class.new("recurly", ".") }

  describe "#with_namespace" do
    it "adds namespace to the given name" do
      expect(subject.with_namespace("account.new")).to eq("recurly.account.new")
    end
  end

  describe "#regexp_wrap" do
    it "wraps the name inside the namespace as regexp" do
      escaped_name = Regexp.escape("recurly.account.new")
      expect(subject.regexp_wrap("account.new")).to eq(/^#{escaped_name}/)
    end
  end

  describe "#parse_with_namespace" do
    it "parses a recurly event and add namespace to it" do
      expect(subject.parse_with_namespace("new_account_notification")).to eq("recurly.account.new")
      expect(subject.parse_with_namespace("past_due_invoice_notification")).to eq("recurly.invoice.past_due")
      expect(subject.parse_with_namespace("billing_info_updated_notification")).to eq("recurly.billing_info.updated")
    end
  end
end
