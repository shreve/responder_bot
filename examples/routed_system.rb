require 'responder_bot'

#
# This top-level controller handles all incoming responses
#
class ResponseController < ResponderBot::Handler
  matchers help: Regexp.new('^he?l?p?', 'i'),
           balance: Regexp.new('^bala?n?c?e?', 'i')

  # Any missing methods here are delegated to `respondable`, which is the only
  # parameter used to instantiate this class.
  handle_response do |reply|
    # Prefer to interact with your respondable before anything else
    if response_handler.understands_reply?
      reply.any { response_handler.handle_response! }
    end

    if user.nil?
      reply.any do
        "We don't know who you are. You'll need to create an account before " \
        'you can use this SMS system.'
      end
    end

    reply.help do
      'This is the SMS help text. Reply BAL to see your balance.'
    end

    reply.balance do
      "You have #{user.points} points to spend."
    end

    # If you want help and balance to always be preferred over your respondable,
    # just move this matcher to the bottom.
    if response_handler.understands_reply?
      reply.any { response_handler.handle_response! }
    end

    reply.any do
      "We didn't understand what you said. Reply HELP for more info."
    end
  end
end

#
# This is your application object you want users to interact with, like a
# question, support ticket, or order.
#
class Respondable
  belongs_to :user

  def body
    'SMS Response'
  end

  def response_handler
    RespondableResponseHandler.new(self)
  end

  def status
    :provided_address
  end

  def stop_order!
  end

  def delivery_method=(val)
    super(val)
  end
end

#
# This is your object-specific handler. It can use the data available in
# respondable to power it. For example, Respondable can be used as a state
# machine to power a multi-step wizard.
# The design inspiration for this gem was an SMS-only reward checkout wizard.
#
class RespondableResponseHandler < RespondableBot::Handler
  matcher exit: Regexp.new('^ex?i?t?', 'i'),
          x_it: /^[Xx]/
  handle_response do |reply|
    reply.any_of(:quit, :exit, :x_it) do
      stop_order!
      'Your order has been stopped. You can try again later.'
    end

    case status
    when :asked_for_delivery_method
      read_delivery_method_prompt
    end
  end

  # You can use methods to defer large chunks of behavior you don't want inline
  # inside handle_response
  def read_delivery_method_prompt(reply)
    reply
      .is('A') { respondable.delivery_method = :SMS }
      .is('B') { respondable.delivery_method = :email }
      .is('C') { respondable.delivery_method = :mail }
      .is('D') { respondable.delivery_method = :local_pickup }
  end
end

#
# Now that the classes are defined, let's look at how to use them.
#

# 1. Find an object to respond to. This usually works well by searching using
#    the phone number of the incoming SMS
respondable = Respondable.find_by(phone_number: params[:phone_number])

# 2. Pass the respondable to the main controller
controller = ResponseController.new(respondable)

# 3. Use the controller to do the cool things your app does and generate a reply
reply = controller.handle_response!

# 4. Send the reply back to your user, perhaps using TwiML if you use Twilio
#    (Shout out to Twilio. I love you. Please send me Twilio swag and credits)
render xml: Twilio::TwiML::Response.new do |t|
              t.Sms reply
            end.text
