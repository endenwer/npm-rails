# npm-rails

NPM support for Rails projects. It let you use Bundler-like DSL and rake tasks
for including npm packages. This gem based on Browserify for bundling packages
and resolve dependencies.

**requirement**

* [node](http://nodejs.org)
* [browserify](http://browserify.org/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'npm-rails'
```

Then run:

    rails g npm_rails:initialize

And require `npm-dependencies.js`:

    //=require npm-dependencies

## Usage

1. Add a package to `npm_packages` file
2. Run `rake npm:install`
3. Use the package in your javascript code by calling the camelize name
or `build_name` if you set it

**Example `npm_packages` file**

```ruby
# call 'React' in your js code to use it
npm 'react'

# Set version
npm 'redux', '3.3.1'

# Set build_name to a package.
# Call '_' to get Underscore
npm 'underscore', build_name: '_'

# You can add a package for development
npm 'jasmine', development: true

# Or in block
development do
  npm 'jasmine'
end

# Install a package but do not require it
npm 'browserify', require: false
```
