Rails.application.routes.draw do
  mount GenericApiResource::Engine => "/generic_api_resource"
end
