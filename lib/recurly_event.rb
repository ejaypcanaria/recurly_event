require "active_support/notifications"
require "recurly_event/version"
require "recurly_event/engine" if defined? Rails

module RecurlyEvent
  class << self
    attr_accessor :notifications
  end

  self.notifications = ActiveSupport::Notifications
end
