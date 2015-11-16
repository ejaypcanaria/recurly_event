require "spec_helper"

describe RecurlyEvent::Parser do
  let(:xml_string) { "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<new_account_notification>\n  <account>\n    <account_code>4</account_code>\n    <username>john.lennon</username>\n    <email>john.lennon@thebeatles.com</email>\n    <first_name>John</first_name>\n    <last_name>Lennon</last_name>\n    <company_name>The Beatles</company_name>\n  </account>\n</new_account_notification>\n" }

  let(:request) { double(:request, body: double(string: xml_string)) }
  let(:payload) { described_class.parse(request).payload }
  subject { described_class.parse(request) }

  describe ".from_payload" do
    subject { described_class.from_payload(payload) }

    it "is an open struct" do
      expect(subject.class).to eq(OpenStruct)
    end

    it "adds xml values to the object attributes" do
      expect(subject.account).not_to be nil
      expect(subject.account.account_code).to eq("4")
      expect(subject.account.username).to eq("john.lennon")
      expect(subject.account.email).to eq("john.lennon@thebeatles.com")
      expect(subject.account.first_name).to eq("John")
      expect(subject.account.last_name).to eq("Lennon")
      expect(subject.account.company_name).to eq("The Beatles")
    end
  end

  describe "#event_name" do
    it "extracts the event name from the xml response" do
      expect(subject.event_name).to eq("new_account_notification")
    end
  end

  describe "#payload" do
    it "is a hash from the xml" do
      expect(payload).to have_key("account")
      expect(payload["account"]).to have_key("account_code")
      expect(payload["account"]).to have_key("username")
      expect(payload["account"]).to have_key("email")
      expect(payload["account"]).to have_key("first_name")
      expect(payload["account"]).to have_key("last_name")
      expect(payload["account"]).to have_key("company_name")
    end

    it "includes the event name" do
      expect(payload["event"]).to eq("new_account_notification")
    end
  end

  context "when the request body does not respond to string" do
    let(:request) { double(:request, body: double(read: xml_string)) }

    it "parses the XML properly" do
      expect(payload["account"]).not_to be_empty
      expect(payload["event"]).to eq("new_account_notification")
    end
  end
end
