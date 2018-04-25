module ResponderBot
  #
  # Matcher List
  #
  # Contains the list of available named matchers for a given handler as well
  # as the map from matchers to actions.
  #
  # Note: Not all matchers need a name. match, is, exactly, and any all create
  # anonymous matchers.
  #
  class MatcherList
    attr_accessor :actions, :matchers

    def initialize(use_defaults = true)
      self.actions = {}
      self.matchers = if use_defaults
                        ResponderBot.default_matchers
                      else
                        false
                      end
    end

    def matches?(text)
      !action_for(text).nil?
    end

    # Use any of the named matchers to call this action
    def any_of(*matcher_names, &action)
      matcher_names.each do |name|
        append_action(matchers[name], action)
      end
      self
    end

    # Provide a regex to use one time
    def match(regex, &action)
      append_action(regex, action)
      self
    end

    # Case-insensitive comparison
    def is(string, &action)
      append_action(Regexp.new(string, 'i'), action)
      self
    end

    # Case-sensitive comparison
    def exactly(string, &action)
      append_action(string, action)
      self
    end

    # Always matches
    def any(&action)
      append_action(true, action)
    end

    def define_matcher(matcher_name, matcher)
      matchers[matcher_name] = matcher
    end

    def method_missing(method_name, *args, &block)
      if matchers.key?(method_name)
        append_action(matchers[method_name], block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, *)
      matchers.key?(method_name)
    end

    private

    def append_action(matcher, action)
      actions[matcher] = action
    end

    def action_for(text)
      actions.each_pair do |matcher, action|
        return action if matcher_matches?(matcher, text)
      end
      nil
    end

    def matcher_matches?(matcher, text)
      case matcher
      when TrueClass then true
      when Regexp then matcher.match?(text)
      when Proc
        matcher.arity.zero? ? matcher.call : matcher.call(text)
      when String then matcher == text
      end
    end
  end
end
