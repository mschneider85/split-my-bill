class MessagesController < ApplicationController
  before_action :load_conversation

  def index
    @messages = @conversation.messages.order(created_at: :desc)
    if @messages.length > 10
      @over_ten = true
      @messages = @messages.limit(10)
    end
    if params[:m]
      @over_ten = false
      @messages = @conversation.messages
    end
    if @messages.last
      if @messages.last.user_id != current_user.id
        @messages.last.update_columns(read: true)
      end
    end
    @message = @conversation.messages.new
  end

  def new
    @message = @conversation.messages.new
  end

  def create
    @message = @conversation.messages.new(message_params)
    if @message.save
      redirect_to conversation_messages_path(@conversation)
    end
  end

  private

  def load_conversation
    @conversation = Conversation.find_by(id: params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:body, :user_id)
  end
end
