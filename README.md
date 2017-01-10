# HashCast
[![Build Status](https://travis-ci.org/ddd-ruby/hashcast.png)](https://travis-ci.org/ddd-ruby/hashcast)
[![Code Climate](https://codeclimate.com/github/ddd-ruby/hashcast/badges/gpa.svg)](https://codeclimate.com/github/ddd-ruby/hashcast)
[![codecov](https://codecov.io/gh/ddd-ruby/hashcast/branch/master/graph/badge.svg)](https://codecov.io/gh/ddd-ruby/hashcast)
[![Dependency Status](https://gemnasium.com/ddd-ruby/hashcast.png)](https://gemnasium.com/ddd-ruby/hashcast)


HashCast is a library for casting hash attributes


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hashcast'
```

### Usage

Create caster class and declare hash attributes inside:

```ruby
class ContactCaster
  include HashCast::Caster

  attributes do
    hash :contact do
      string   :name
      integer  :age, optional: true
      float    :weight
      date     :birthday
      datetime :last_logged_in
      time     :last_visited_at
      hash :company do
        string :name
      end
      array :emails, each: :string
      array :social_accounts, each: :hash do
        string :name
        symbol :type
      end
    end
  end
end
```

Instantiate the caster and give your hash for casting:

```ruby
ContactCaster.cast({
    contact: {
      name: "John Smith",
      age: "22",
      weight: "65.5",
      birthday: "2014-02-02",
      last_logged_in: "2014-02-02 10:10:00",
      last_visited_at: "2014-02-02 10:10:00",
      company: {
        name: "MyCo"
      },
      emails: ["test@example.com", "test2@example.com"],
      social_accounts: [
        {
          name: "john_smith",
          type: "twitter"
        },
        {
          name: "John",
          type: :facebook
        }
      ]
    }
  }
})
```

The caster will cast your hash attributes to:

```ruby
{
  contact: {
    name: "John Smith",
    age: 22,
    weight: 65.5,
    birthday: #<Date: 2014-02-02 ((2456691j,0s,0n),+0s,2299161j)>,
    last_logged_in: #<DateTime: 2014-02-02T10:10:00+00:00 ((2456691j,36600s,0n),+0s,2299161j)>,
    last_visited_at: 2014-02-02 10:10:00 +0400,
    company: {
      name: "MyCo"
    },
    emails: ["test@example.com", "test2@example.com"],
    social_accounts: [
      {
        name: "john_smith",
        type: :twitter"
      },
      {
        name: "John",
        type: :facebook
      }
    ]
  }
}
```

if some of the attributes can't be casted the HashCast::Errors::CastingError is raised


Also you can provide options to every caster about expected keys type for input/output (:symbol / :string)

```ruby
class SettingsCaster
  include HashCast::Caster

  attributes do
    string :account
  end
end
SettingsCaster.cast({account: "some"}, input_keys: :symbol, output_keys: :string)
# => {"account" => "some"}
```


## Configuration


```ruby
# expect all input keys to be strings
HashCast.config.input_keys  = :string

# expect all output keys to be symbols
HashCast.config.output_keys = :symbol
```

## Authors

- Albert Gazizov, [@deeper4k](https://twitter.com/deeper4k)
- Roman Heinrich, [@mindreframer](https://twitter.com/mindreframer)
