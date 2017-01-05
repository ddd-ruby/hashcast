# run with `ruby benchmark/benchmark.rb`
require 'bundler'
Bundler.setup
require 'benchmark'
require 'hashcast'
require 'bixby/bench'

require_relative "casters"

class CastingBenchmark
  def input_contact
   @input_contact ||= {
      contact: {
        name: "John Smith",
        age: "22",
        weight: "65.5",
        birthday: "2014-02-02",
        last_logged_in: "2014-02-02 10:10:00",
        last_visited_at: "2014-02-02 10:10:00",
        company: {
          name: "MyCo",
        },
        emails: [ "test@example.com", "test2@example.com" ],
        social_accounts: [
          {
            name: "john_smith",
            type: 'twitter',
          },
          {
            name: "John",
            type: :facebook,
          },
        ]
      }
    }
  end

  def input_company
    @input_company ||= {
      name: 'Might & Magic',
      settings: {
        account: :'migthy_lord'
      },
      emails: [
        { address: :'test1@example.com' },
        { address: :'test2@example.com' },
      ]
    }
  end

  def self.run
    instance = CastingBenchmark.new
    times = 10_000
    Bixby::Bench.run(times) do |b|
      puts "calling #{times} times..."
      b.sample('Contact Caster') do
        ContactCaster.cast(instance.input_contact)
      end

      b.sample("CompanyCaster") do
        CompanyCaster.cast(instance.input_company)
      end
    end
  end
end

CastingBenchmark.run

