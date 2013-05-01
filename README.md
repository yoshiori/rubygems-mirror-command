# Rubygems::Mirror::Command

gem mirror fetcher and start mirror server.

## Installation

Add this line to your application's Gemfile:

```ruby:Gemfile
gem "rubygems-mirror-command", :git => "git@github.com:yoshiori/rubygems-mirror-command.git"
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ git clone git@github.com:yoshiori/rubygems-mirror-command.git
$ cd rubygems-mirror-command
$ gem build rubygems-mirror-command.gemspec
$ rubygems-mirror-command-0.0.1.gem
```

## Usage

### fetch files
```
$ rubygems-mirror-command fetch
```

### start server

```
$ rubygems-mirror-command server
```

Or specified Port

```
$ rubygems-mirror-command server 3999
```

### install gem for local mirror

```
$ gem install rails -r --source http://localhost:4000/
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
