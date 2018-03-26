# Alerty::Plugin::Stackdriver

Google Stackdriver plugin for alerty (https://github.com/sonots/alerty)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'alerty-plugin-stackdriver'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install alerty-plugin-stackdriver

## Configuration

* **type**: must be `stackdriver`.
* **keyfile**: service account keyfile path.
* **project_id**: your GCP project id.
* **log_name**: Stackdriver log name.
* **resource_type**: Stackdriver Logging monitored resource types. https://cloud.google.com/logging/docs/api/v2/resource-list
* **resource_labels**: Stackdriver Logging monitored resource labels. https://cloud.google.com/logging/docs/api/v2/resource-list
* **message**: message of alert. `${command}` is replaced with a given command, `${hostname}` is replaced with the hostname ran the command, `${output}` is replaced with the output. The default is `${output}`.


```
log_path: STDOUT
log_level: debug
plugins:
  - type: stackdriver
    keyfile: "example_keyfile.json"
    project_id: "example_project"
    log_name: "example_alerty_log"
    resource_type: "gae_app"
    resource_labels:
      module_id: "1"
      version_id: "20150925t173233"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/potato2003/alerty-plugin-stackdriver.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
