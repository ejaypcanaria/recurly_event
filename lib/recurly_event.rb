require "active_support/notifications"
require "recurly_event/version"
require "recurly_event/namespace"
require "recurly_event/parser"
require "recurly_event/engine" if defined? Rails

module RecurlyEvent
  NAMESPACE = "recurly".freeze

  class << self
    attr_accessor :notifications, :namespace, :parser
  end

  self.parser        = Parser
  self.namespace     = Namespace.new(NAMESPACE, ".")
  self.notifications = ActiveSupport::Notifications
end
