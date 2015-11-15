require "spec_helper"

describe RecurlyEvent::Parser do
  let(:xml_string) { "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<new_account_notification>\n  <account>\n    <account_code>4</account_code>\n    <username>john.lennon</username>\n    <email>john.lennon@thebeatles.com</email>\n    <first_name>John</first_name>\n    <last_name>Lennon</last_name>\n    <company_name>The Beatles</company_name>\n  </account>\n</new_account_notification>\n" }

  let(:request) { double(:request, body: double(string: xml_string)) }
  subject { described_class.parse(request) }

  describe "#event_name" do
    it "extracts the event name from the xml response" do
      expect(subject.event_name).to eq("new_account_notification")
    end
  end

  describe "#recurly_object" do
    let(:recurly_object) { subject.recurly_object }

    it "is an open struct" do
      expect(recurly_object.class).to eq(OpenStruct)
    end

    it "adds xml values to the object attributes" do
      expect(recurly_object.account).not_to be nil
      expect(recurly_object.account.account_code).to eq("4")
      expect(recurly_object.account.username).to eq("john.lennon")
      expect(recurly_object.account.email).to eq("john.lennon@thebeatles.com")
      expect(recurly_object.account.first_name).to eq("John")
      expect(recurly_object.account.last_name).to eq("Lennon")
      expect(recurly_object.account.company_name).to eq("The Beatles")
    end
  end
end
