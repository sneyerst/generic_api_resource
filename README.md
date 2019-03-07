# GenericApiResource

This gem is a controller abstraction layer for REST resources, including support for Devise and Cancancan.

## Usage
Create a controller, make sure to at least pass 4 properties:

```
class Api::V1::MyResourcesController < GenericApiResource::BaseController
  RESOURCE_CLASS = MyResource
  RESOURCE_NAME_SINGULAR = :my_resource
  RESOURCE_NAME_PLURAL = :my_resources
  RESOURCE_VIEW = :my_resources
end
```

### Allow creation/updating of a resource

If you want to update this resource via this controller, add a whitelist:

```
  # resource_params is a fixed name: don't change this!
  def resource_params
    params.require(:my_resources).permit(:attr1, :attr2, ...)
  end
```

### Filtering in the index action

If you want to allow filters for the index action, add an additional whitelist:

```
  # filter_params is a fixed name: don't change this!
  def filter_params
    params.permit(:field1, :field2, ...)
  end
```

Then, add for each of the allowed fields a name scope in the previously configured model.
The name of the scope must be `filter_{field}`.

## Generating views

You need views for 2 actions: index and show. Currently, the show view is also used for new, create, edit and update.

Basic index.json.jbuilder file:

```
json.set! :response do
  json.set! :metadata do
    # ... any metadata you want ...
  end
  json.data(@generic_resources) do |generic_resource|
    json.id generic_resource.id
    # ... your additional resource attributes ...
  end
end
```

Basic index.json.jbuilder file:

```
json.set! :response do
 json.set! :metadata do
   # ... any metadata you want ...
 end
  json.set! :data do
    json.id @generic_resource.id
    # ... your additional resource attributes ...
  end
end
```

### Generating a simple form

in show.json.jbuilder, add a `fields` set to metadata:
```
json.set! :response do
  json.set! :metadata do
    json.set! :fields do
      json.my_field do
        json.initial_value [@generic_resource.my_field || '']
        json.label 'My field'
        json.type 'textfield'
      end
    end
  end
  # ...
end
```

Supported field types right now are: textfield, textarea, dropdown, checkbox, accordion.
You will need to also provide a `values` set, which will be used for the Angular form builder in generic-api-resource-client-lib.


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'generic_api_resource'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install generic_api_resource
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
