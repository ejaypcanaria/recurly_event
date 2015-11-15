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
end
