module RecurlyEvent
  class WebhookController < ActionController::Base
    def event
      RecurlyEvent.process_request(request)
      head :ok
    end
  end
end
