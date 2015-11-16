require "json"
require "active_support/core_ext/hash"

module RecurlyEvent
  class Parser
    def self.parse(request)
      new(request)
    end

    def self.from_payload(payload)
      JSON.parse(payload.to_json, object_class: OpenStruct)
    end

    def initialize(request)
      @request = request
    end

    def event_name
      hash_from_request.first.first
    end

    def payload
      payload = hash_from_request.first.last
      payload.merge("event" => event_name)
    end

  private

    def hash_from_request
      # see https://recurly.readme.io/v2.0/page/webhooks for the xml structure
      @hash_from_request ||= Hash.from_xml(@request.body.string)
    end
  end
end
