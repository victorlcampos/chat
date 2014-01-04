class MessagesController < ApplicationController
  def index
    @messages = Message.all
  end

  def create
    Message.create!(params.require(:message).permit(:name, :content))
    redirect_to messages_path
  end
end
