# ddr-models

[![Build Status](https://travis-ci.org/duke-libraries/ddr-models.svg?branch=develop)](https://travis-ci.org/duke-libraries/ddr-models)
[![Gem Version](https://badge.fury.io/rb/ddr-models.svg)](http://badge.fury.io/rb/ddr-models)

A Rails engine providing Hydra and ActiveRecord models and common services for the Duke Digital Repository.

## Installation

Add to your application's Gemfile:

    gem 'ddr-models'
    
and

    bundle install

## Configuration

ddr-models has several runtime dependencies that are independently configurable:

- [active_fedora](https://github.com/projecthydra/active_fedora)
- [hydra-head](https://github.com/projecthydra/hydra-head)
- [ddr-antivirus](https://github.com/duke-libraries/ddr-antivirus)
- [devise-remote-user](https://github.com/duke-libraries/devise-remote-user)

ddr-models configuration options:

- Authentication/Authorization options are set on [Ddr::Auth](http://www.rubydoc.info/gems/ddr-models/Ddr/Auth).

### Additional configuration steps

#### User model

Include `Ddr::Auth::User` in `app/models/user.rb` and remove content inserted by Hydra, Blacklight and Devise generators:

```ruby
class User
  include Ddr::Auth::User
  #
  # Remove content inserted by Hydra, Blacklight, or Devise generators --
  # it's provided by Ddr::Auth::User.
  #
  # include Blacklight::User
  # include Hydra::User
  # devise :database_authenticatable [...]
  #
  # ... as well as any methods.
  #
  # You can add custom methods for the app as needed.
  #
end
```

#### Ability class

The hydra-head generator may have created a class module at `app/models/ability.rb` like so:

```ruby
class Ability
  include Hydra::Ability
end
```

Change the class like so:

```ruby
class Ability < Ddr::Auth::Ability
  #
  # Ddr::Auth::Ability includes Hydra::PolicyAwareAbility
  # include Hydra::Ability
  #
  # Add custom methods here as needed to Ability.ability_logic:
  #
  # self.ability_logic += [:my_ability]
  #
  # def my_ability
  #   # whatever
  # end
  #
end
```

#### Migrations

Install the ddr-models migrations:

    rake ddr_models:install:migrations
    
then

    rake db:migrate db:test:prepare
    
