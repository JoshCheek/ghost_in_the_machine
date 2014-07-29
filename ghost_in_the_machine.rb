require 'mechanize'
class GhostInTheMachine
  Agent = Mechanize::HTTP::Agent

  def self.fuck(method_name)
    define_method method_name do |*args, &block|
      real_agent.__send__ method_name, *args, &block
    end
  end

  attr_accessor :real_agent  # let it do jobs we don't care about
  fuck :http                 # https://github.com/sparklemotion/mechanize/blob/c3c3b6ef217e38b373d19608210c92f92803b54a/test/test_mechanize_http_agent.rb#L35
  fuck :auto_io              # https://github.com/sparklemotion/mechanize/blob/c3c3b6ef217e38b373d19608210c92f92803b54a/lib/mechanize/http/agent.rb#L1136

  attr_accessor :context     # the Mechanize instance https://github.com/sparklemotion/mechanize/blob/c3c3b6ef217e38b373d19608210c92f92803b54a/lib/mechanize.rb#L190
  attr_accessor :user_agent  # https://github.com/sparklemotion/mechanize/blob/c3c3b6ef217e38b373d19608210c92f92803b54a/lib/mechanize.rb#L194
  attr_accessor :max_history # https://github.com/sparklemotion/mechanize/blob/c3c3b6ef217e38b373d19608210c92f92803b54a/lib/mechanize.rb#L215

  def initialize(name='mechanize', driver=init_poltergeist)
    self.real_agent = Agent.new name
  end

  def init_poltergeist
    nil # FIXME
  end

  # https://github.com/sparklemotion/mechanize/blob/c3c3b6ef217e38b373d19608210c92f92803b54a/lib/mechanize.rb#L219
  def set_proxy(proxy_addr, proxy_port, proxy_user, proxy_pass)
    # shit like this makes it much more obvious to me how little I actually know
  end
end
