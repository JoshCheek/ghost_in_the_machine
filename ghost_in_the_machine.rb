class GhostInTheMachine
  class EverythingIsFine
    def initialize(description, attributes)
      @description = description
      @attributes = attributes
    end

    def inspect
      "#<EverythingIsFine(#{@description}) #{@attributes.keys.inspect}>"
    end

    def name
      @attributes.fetch :name
    end
  end

  attr_accessor :context     # the Mechanize instance https://github.com/sparklemotion/mechanize/blob/c3c3b6ef217e38b373d19608210c92f92803b54a/lib/mechanize.rb#L190
  attr_accessor :user_agent  # https://github.com/sparklemotion/mechanize/blob/c3c3b6ef217e38b373d19608210c92f92803b54a/lib/mechanize.rb#L194
  attr_accessor :max_history # https://github.com/sparklemotion/mechanize/blob/c3c3b6ef217e38b373d19608210c92f92803b54a/lib/mechanize.rb#L215
  attr_accessor :http        # https://github.com/sparklemotion/mechanize/blob/c3c3b6ef217e38b373d19608210c92f92803b54a/test/test_mechanize_http_agent.rb#L35
  def initialize(name='mechanize', driver=init_poltergeist)
    @http = EverythingIsFine.new('Fake HTTP', name: name)
  end

  def init_poltergeist
    nil # FIXME
  end

  # https://github.com/sparklemotion/mechanize/blob/c3c3b6ef217e38b373d19608210c92f92803b54a/lib/mechanize.rb#L219
  def set_proxy(proxy_addr, proxy_port, proxy_user, proxy_pass)
    # shit like this makes it much more obvious to me how little I actually know
  end
end
