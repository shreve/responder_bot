module ResponderBot
  class Handler
    def self.inherited(child)
      child.class_eval do
        class << self
          attr_accessor :matcher_list, :response_handler
        end
        self.matcher_list = MatcherList.new
      end
    end

    attr_accessor :respondable, :body

    def initialize(respondable)
      self.respondable = respondable
      self.body = if respondable.is_a?(String)
                    respondable
                  else
                    respondable.body
                  end
      instance_eval(&self.class.response_handler)
    end

    def understands_reply?
      matcher_list.matches?(body)
    end

    def handle_response!
      if understands_reply?
        matcher_list.action_for(body).call
      else
        raise ResponderBot::UnmatchedResponse,
              "No matcher caught input '#{body}'."
      end
    end

    def matcher_list
      self.class.matcher_list
    end

    def self.handle_response(&block)
      self.response_handler = block
    end

    def self.matcher(new_matchers)
      new_matchers.each_pair do |name, match|
        matcher_list.define_matcher(name, match)
      end
    end

    def method_missing(method_name, *args, &block)
      if self.class.matcher_list.respond_to?(method_name)
        self.class.matcher_list.send(method_name, *args, &block)
      elsif respondable.respond_to?(method_name)
        respondable.send(method_name, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name)
      self.class.matcher_list.respond_to?(method_name)
    end
  end
end
