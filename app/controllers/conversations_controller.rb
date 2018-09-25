class ConversationsController < ApplicationController

  # grab all messages from the conversation
  def index
    conversations = Conversation.all
    render json: conversations
  end

  # saves received data and broadcasts data to channels
  def create
    conversation = Conversation.new(conversation_params)

    if conversation.save
      serialized_data = ActiveModelSerializers::Adapter::Json.new(
        ConversationSerializer.new(conversation)
      ).serializable_hash
      ActionCable.server.broadcast 'conversations_channel', serialized_data
      head :ok
    end

  end

  private

  def conversation_params
    params.require(:conversation).permit(:title)
  end

end
