module GenericApiResource
  class Engine < ::Rails::Engine
    isolate_namespace GenericApiResource
    config.generators.api_only = true
  end
end
