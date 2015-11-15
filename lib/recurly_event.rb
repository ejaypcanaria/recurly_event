require "active_support/notifications"
require "recurly_event/version"
require "recurly_event/namespace"
require "recurly_event/parser"
require "recurly_event/engine" if defined? Rails

module RecurlyEvent
  NAMESPACE = "recurly".freeze

  class << self
    attr_accessor :notifications, :namespace, :parser

    def configure(&block)
      raise ArgumentError, "missing block" unless block_given?
      yield self
    end

    def process_request(request)
      parsed_request = parser.parse(request)
      publish(parsed_request.event_name, parsed_request.payload)
    end

    def publish(event_name, payload)
      notifications.instrument(namespace.parse_with_namespace(event_name), payload)
    end

    def subscribe(event_name, callable=Proc.new {})
      notifications.subscribe namespace.regexp_wrap(event_name) do |*args|
        recurly_object = parser.from_payload(args.last)
        callable.call(recurly_object)
      end
    end
  end

  self.parser        = Parser
  self.namespace     = Namespace.new(NAMESPACE, ".")
  self.notifications = ActiveSupport::Notifications
end
