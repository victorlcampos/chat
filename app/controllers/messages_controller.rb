require 'server_sent_event/sse'
class MessagesController < ApplicationController
  include ActionController::Live

  def index
    @messages = Message.all
  end

  def create
    message_params = params.require(:message).permit(:name, :content)
    @message = Message.new(message_params)

    if @message.save
      response.headers['Content-Type'] = 'text/javascript'

      stream_subscription_service = StreamSubscriptionService.new
      stream_subscription_service.publish('messages.create', message_params.to_json)
    end

    render nothing: true
  end

  def subscription
    response.headers['Content-Type'] = 'text/event-stream'
    sse = ServerSentEvent::SSE.new(response.stream)

    stream_subscription_service = StreamSubscriptionService.new
    stream_subscription_service.subscribe(sse, 'messages.create')

    render nothing: true
  rescue IOError
    # Client disconnected
  ensure
    stream_subscription_service.quit
    sse.close
  end
end
