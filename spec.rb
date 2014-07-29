# vim -O spec.rb ghost_in_the_machine.rb ~/.gem/ruby/2.1.1/gems/mechanize-2.7.3/test/test_mechanize_http_agent.rb

require_relative 'ghost_in_the_machine'

class ToQuoteMitch…ThisPlaceIsHaunted
  class FakeMech
    attr_reader :agent

    def initialize
      @agent = GhostInTheMachine.new('Mechanize', Mock::PoltergeistDriver.new)
    end
  end

  module Mock
    class PoltergeistDriver
    end
  end
end

module PortalIntoAnotherWorld
  def setup
    super # calls Mechanize::TestCase#setup
    @mech = ToQuoteMitch…ThisPlaceIsHaunted::FakeMech.new
  end
end


# Load up the Mechanize::HTTP::Agent test suite
mechanize_gemspec = Gem::Specification.find_by_path 'mechanize'
test_path = File.join mechanize_gemspec.full_gem_path, 'test'
$LOAD_PATH << test_path
require 'test_mechanize_http_agent'

# Inject ourselves so we can run their tests against ours
class TestMechanizeHttpAgent
  include PortalIntoAnotherWorld
  i_suck_and_my_tests_are_order_dependent!
end

# Some tests talk directly to Agent
Mechanize::HTTP.send :remove_const, :Agent
Mechanize::HTTP::Agent = GhostInTheMachine

# I'm failing 141 tests to start out with, want an RSpec style --fail-fast,
# since the reporter gets notified after each test run,
# we'll add one that dies if it fails (otherwise, the feedback is not as good )
Minitest.extensions << 'ghost_in_the_machine'
module Minitest
  def self.plugin_ghost_in_the_machine_init(*)
    Minitest.reporter << FailFastReporter.new
  end

  class FailFastReporter < Reporter
    def initialize(*)
      super
      @summary_reporter = SummaryReporter.new # I still want to see the failure message, even though I'm exiting the process early
    end

    def start
      @summary_reporter.start
    end

    def record(result)
      @summary_reporter.record result
      return unless result.failures.any?
      def result.to_s
        failures.map { |failure|
          "#{failure.result_label}:\n\e[32m#{self.location}:\n\e[36m#{failure.message}\e[0m\n"
        }.join "\n"
      end
      @summary_reporter.report
      exit!
    end
  end

  class UnexpectedError
    # Just colouring shit in a way that will hopefully make it less tiring to get through some of this
    # ...or maybe just wasting time b/c I'm scared to start, idk
    def message
      bt = Minitest.filter_backtrace(self.backtrace)
                   .tap { |filtered|
                     filtered.select { |line| line =~ /test_mechanize_http_agent.rb/ }
                             .max_by { |line| line[/(?<=:)\d+/].to_i }
                             .tap { |maybe_relevant_line|
                               maybe_relevant_line.sub! '/test/', "/\e[35mtest/"
                               maybe_relevant_line.sub! /:\d+/, "\\1\e[0m"
                             }
                   }
                   .join("\n    ")
      "\e[33m#{self.exception.class}\e[0m: \e[31m#{self.exception.message}\e[0m\n    #{bt}"
    end
  end
end
