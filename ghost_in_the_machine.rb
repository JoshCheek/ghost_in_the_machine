require 'mechanize'
class GhostInTheMachine
  Agent = Mechanize::HTTP::Agent

  # BEGIN SECTION OF STUFF I'M TOTALLY PUNTING ON
      # https://www.youtube.com/watch?v=XRvpGGc9Jv8
      def self.i_dont_give_a_fuck_about(method_name)
        define_method method_name do |*args, &block|
          real_agent.__send__ method_name, *args, &block
        end
      end

      attr_accessor :real_agent  # let it do jobs we don't care about
      i_dont_give_a_fuck_about :http                 # https://github.com/sparklemotion/mechanize/blob/c3c3b6ef217e38b373d19608210c92f92803b54a/test/test_mechanize_http_agent.rb#L35
      i_dont_give_a_fuck_about :auto_io              # https://github.com/sparklemotion/mechanize/blob/c3c3b6ef217e38b373d19608210c92f92803b54a/lib/mechanize/http/agent.rb#L1136
      i_dont_give_a_fuck_about :set_proxy            # https://github.com/sparklemotion/mechanize/blob/c3c3b6ef217e38b373d19608210c92f92803b54a/lib/mechanize.rb#L219
      i_dont_give_a_fuck_about :max_history          # https://github.com/sparklemotion/mechanize/blob/c3c3b6ef217e38b373d19608210c92f92803b54a/lib/mechanize.rb#L215
      i_dont_give_a_fuck_about :max_history=
      i_dont_give_a_fuck_about :max_file_buffer=
      i_dont_give_a_fuck_about :certificate
      i_dont_give_a_fuck_about :certificate=
      i_dont_give_a_fuck_about :to_pem
      i_dont_give_a_fuck_about :connection_for
      i_dont_give_a_fuck_about :disable_keep_alive
      i_dont_give_a_fuck_about :keep_alive=
      i_dont_give_a_fuck_about :enable_gzip
      i_dont_give_a_fuck_about :gzip_enabled=
      i_dont_give_a_fuck_about :history
      # amusingly, this is a giant list of things I probably don't understand
      # which makes me somewhat interested in trying to do them anyway
      # which means I kiiiiiinda do give a fuck!
  # END SECTION OF STUFF I'M TOTALLY PUNTING ON

  attr_accessor :context     # the Mechanize instance https://github.com/sparklemotion/mechanize/blob/c3c3b6ef217e38b373d19608210c92f92803b54a/lib/mechanize.rb#L190
  attr_accessor :user_agent  # https://github.com/sparklemotion/mechanize/blob/c3c3b6ef217e38b373d19608210c92f92803b54a/lib/mechanize.rb#L194
  attr_accessor :allowed_error_codes
  def initialize(name='mechanize', driver=new_poltergeist_driver)
    self.real_agent          = Agent.new name
    self.allowed_error_codes = []
  end

  def new_poltergeist_driver
    # Capybara::Poltergeist::Driver.new(nil)
  end

  def fetch(uri, method, headers, parameters, referer)
    # poltergeist doesn't offer an ability to pass an arbitrary method
    # looking at visit, it appears the flow is like this:
    #   https://github.com/teampoltergeist/poltergeist/blob/b7271f286b40fae6fdafb0f824e0acf1e212b105/lib/capybara/poltergeist/driver.rb#L89
    #   https://github.com/teampoltergeist/poltergeist/blob/b7271f286b40fae6fdafb0f824e0acf1e212b105/lib/capybara/poltergeist/browser.rb#L30
    #   https://github.com/teampoltergeist/poltergeist/blob/b7271f286b40fae6fdafb0f824e0acf1e212b105/lib/capybara/poltergeist/browser.rb#L280-283
    #   https://github.com/teampoltergeist/poltergeist/blob/b7271f286b40fae6fdafb0f824e0acf1e212b105/lib/capybara/poltergeist/client/browser.coffee#L50-52
    #   https://github.com/teampoltergeist/poltergeist/blob/b7271f286b40fae6fdafb0f824e0acf1e212b105/lib/capybara/poltergeist/client/browser.coffee#L84-92
    #   trickily, this is not a Phantom webpage, it's a Poltergeist webpage, but it gets delegated to a real one
    #   https://github.com/teampoltergeist/poltergeist/blob/b7271f286b40fae6fdafb0f824e0acf1e212b105/lib/capybara/poltergeist/client/web_page.coffee#L6
    #   https://github.com/teampoltergeist/poltergeist/blob/b7271f286b40fae6fdafb0f824e0acf1e212b105/lib/capybara/poltergeist/client/web_page.coffee#L29-32
    #   https://github.com/teampoltergeist/poltergeist/blob/b7271f286b40fae6fdafb0f824e0acf1e212b105/lib/capybara/poltergeist/client/web_page.coffee#L13
    # so it ultimately resulting in @native[delegate].apply(@native, arguments)
    # where @native[delegate] is the Phantom page
    # which we can see could take the method here http://phantomjs.org/api/webpage/method/open.html
    #
    # I looked around and there doesn't appear to be anything that directly exposes the ability to set the method
    # So I'm thinking either (and not in any particular order)
    #   * hack a fetch method into Capybara
    #   * see if there's a way to inject a form that would give us the abiltiy to use other methods
    #   * see if there's a way to inject javascript
    #   * skip the poltergeist portion and write our own (that sounds like a lot of work)
    #
    # WRT the headers, the driver has headers=, which ultimately gets to
    # https://github.com/teampoltergeist/poltergeist/blob/b7271f286b40fae6fdafb0f824e0acf1e212b105/lib/capybara/poltergeist/client/web_page.coffee#L172-173
    # which calls @native.customHeaders = headers
    # so that seems doable :D
  end
end
