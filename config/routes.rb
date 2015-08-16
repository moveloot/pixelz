Pixelz::Engine.routes.draw do
  resources :modification_fulfillments, only: [:create]
end
