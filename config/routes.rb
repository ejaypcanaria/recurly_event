RecurlyEvent::Engine.routes.draw do
  root "webhook#event", via: :post
end
