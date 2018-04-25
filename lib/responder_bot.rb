require 'responder_bot/version'

module ResponderBot
  def self.default_matchers
    {
      quit: Regexp.new('^qu?i?t?', 'i'),
      exit: Regexp.new('^ex?i?t?', 'i'),
      yes: Regexp.new('^y', 'i'),
      no: Regexp.new('^n', 'i'),
      number: /^[0-9]+/,

      # The likert scale is a psychometric scale often used in surveys /
      # questionnaires and has a lot of research backing it's effectiveness.
      # https://en.wikipedia.org/wiki/Likert_scale
      likert: ->(text) { (1..5).cover?(text.strip[0].to_i) }
    }
  end
end

require 'responder_bot/errors'
require 'responder_bot/matcher_list'
require 'responder_bot/handler'
