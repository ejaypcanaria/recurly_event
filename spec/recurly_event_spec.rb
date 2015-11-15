require 'spec_helper'

describe RecurlyEvent do
  it "has a version number" do
    expect(RecurlyEvent::VERSION).not_to be nil
  end

  it "has a notifications" do
    expect(RecurlyEvent.notifications).not_to be nil
  end
end
