require "json"
require "active_support/core_ext/hash"

module RecurlyEvent
  class Parser
    def self.parse(request)
      new(request)
    end

    def initialize(request)
      @request = request
    end

    def event_name
      hash_from_request.first.first
    end

    def recurly_object
      recurly_object_hash = hash_from_request.first.last
      JSON.parse(recurly_object_hash.to_json, object_class: OpenStruct)
    end

  private

    def hash_from_request
      # see https://recurly.readme.io/v2.0/page/webhooks for the xml structure
      @hash_from_request ||= Hash.from_xml(@request.body.string)
    end
  end
end
