require 'spec_helper'

describe RecurlyEvent do
  let(:callable) { Proc.new { |arg| arg }}
  let(:payload)  { {"account" => { "account_code" => "1", "username" => "john.lennon"}} }

  it "has a version number" do
    expect(RecurlyEvent::VERSION).not_to be nil
  end

  it "has a notifications" do
    expect(RecurlyEvent.notifications).not_to be nil
  end

  it "has a namespace" do
    expect(RecurlyEvent.namespace).not_to be nil
  end

  describe "#configure" do
    context "when block is given" do
      it "yields itself to the block" do
        RecurlyEvent.configure do |events|
          expect(events).to eq(RecurlyEvent)
        end
      end
    end

    context "when no block is given" do
      it "raises an argument error" do
        expect { RecurlyEvent.configure }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#all" do
    it "subscribe to all the events" do
      RecurlyEvent.all callable

      expect(callable).to receive(:call)
      RecurlyEvent.publish "new_account_notification", payload

      expect(callable).to receive(:call)
      RecurlyEvent.publish "processing_invoice_notification", payload
    end
  end

  describe "#process_request" do
    let(:xml_string) { "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<new_account_notification>\n<account>\n<account_code>1</account_code>\n<username>john.lennon</username>\n</account>\n</new_account_notification>\n" }
    let(:request) { double(:request, body: double(string: xml_string)) }

    it "process Recurly webhook" do
      expect(RecurlyEvent).to receive(:publish).with("new_account_notification", payload)
      RecurlyEvent.process_request(request)
    end
  end

  describe "#subscribe" do
    it "subscribes to the given event" do
      RecurlyEvent.subscribe "account.new"
      expect(RecurlyEvent.notifications.notifier.listening?("recurly.account.new")).to be_truthy
    end

    context "when an event it subscribes with got published" do
      before do
        RecurlyEvent.subscribe "account.new", callable
      end

      it "processes the event" do
        expect(callable).to receive(:call).with(RecurlyEvent.parser.from_payload(payload))
        RecurlyEvent.publish "new_account_notification", payload
      end
    end

    context "when the event name is a wildcard for a resource events" do
      before do
        RecurlyEvent.subscribe "account.", callable
      end

      it "subscribes to all the events on the resource" do
        expect(callable).to receive(:call)
        RecurlyEvent.publish "new_account_notification", payload

        expect(callable).to receive(:call)
        RecurlyEvent.publish "reactivated_account_notification", payload

        expect(callable).to receive(:call)
        RecurlyEvent.publish "cancelled_account_notification", payload
      end

      it "does not subscribe to other events" do
        expect(callable).not_to receive(:call)
        RecurlyEvent.publish "new_invoice_notification", payload
      end
    end
  end

  describe "#publish" do
    it "notify the subscriber of the event" do
      expect(RecurlyEvent.notifications).to receive(:instrument).with("recurly.account.new", payload)
      RecurlyEvent.publish "new_account_notification", payload
    end
  end
end
