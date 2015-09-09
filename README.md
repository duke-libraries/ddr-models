# ddr-models

A Rails engine providing Hydra and ActiveRecord models and common services for the Duke Digital Repository.

[![Gem Version](https://badge.fury.io/rb/ddr-models.svg)](http://badge.fury.io/rb/ddr-models)
[![Build Status](https://travis-ci.org/duke-libraries/ddr-models.svg?branch=develop)](https://travis-ci.org/duke-libraries/ddr-models)
[![Coverage Status](https://coveralls.io/repos/duke-libraries/ddr-models/badge.png?branch=develop)](https://coveralls.io/r/duke-libraries/ddr-models?branch=develop)
[![Code Climate](https://codeclimate.com/github/duke-libraries/ddr-models/badges/gpa.svg)](https://codeclimate.com/github/duke-libraries/ddr-models)

## Installation

Add to your application's Gemfile:

    gem 'ddr-models'

and

    bundle install

## Configuration

ddr-models has several runtime dependencies that are independently configurable:

- [active_fedora](https://github.com/projecthydra/active_fedora)
- [hydra-head](https://github.com/projecthydra/hydra-head)
- [devise](https://github.com/plataformatec/devise)
- [omniauth-shibboleth](https://github.com/toyokazu/omniauth-shibboleth)
- [ezid-client](https://github.com/duke-libaries/ezid-client)

ddr-models configuration options:

- Authentication/Authorization options are set on [Ddr::Auth](http://www.rubydoc.info/gems/ddr-models/Ddr/Auth).

### Additional configuration steps

#### User model

Include `Ddr::Auth::User` in `app/models/user.rb` and remove content inserted by Hydra and Devise generators:

```ruby
class User
  include Ddr::Auth::User
  #
  # REMOVE:
  # include Hydra::User
  # devise :database_authenticatable [...]
  #
  # DO NOT REMOVE:
  # Blacklight::User
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
  # REMOVE:
  # include Hydra::Ability
  #
  # Add "ability definitions" -- i.e., subclasses of Ddr::Auth::AbilityDefinitions.
  #
  # self.ability_definitions += [ ... ]
  #
end
```

#### Controller

`Ddr::Auth::RoleBasedAccessControlsEnforcement` overrides `current_ability`, `gated_discovery_filters` and `enforce_show_permissions`, so most likely it should be included in `ApplicationController`.

```ruby
class ApplicationController < ActionController::Base

  include Ddr::Auth::RoleBasedAccessControlsEnforcement

end
```

#### SolrDocument model

Include `Ddr::Models::SolrDocument` in `app/models/solr_document.rb`

```ruby
class SolrDocument

  include Blacklight::Solr::Document
  include Ddr::Models::SolrDocument

...

end
```

#### Auxiliary Web Services

In order to use the auxiliary web services, set the `DDR_AUX_API_URL` environment variable.  You may wish to install the [ddr-aux](https://github.com/duke-libraries/ddr-aux) app locally and run it.

#### Migrations

Install the ddr-models migrations:

    rake ddr_models:install:migrations

then

    rake db:migrate db:test:prepare

