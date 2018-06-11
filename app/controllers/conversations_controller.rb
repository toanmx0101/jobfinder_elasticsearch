class ConversationsController < ApplicationController
  before_action :authenticate_user!, only: [:update, :update_all_conversations]


  def index
    @conversations = current_user.conversations.includes(:receiver).order(updated_at: :desc)
    if params[:id].blank?
      @recent_conversation = @conversations.first
      redirect_to conversations_path + '/' + @recent_conversation.id.to_s
    else
      @recent_conversation = Conversation.includes(:receiver).find(params[:id])
    end
    @sended_messages ||= @recent_conversation.messages.order(created_at: :desc)
    @received_messages ||= Conversation.find_by(sender_id: @recent_conversation.receiver_id, receiver_id: current_user.id).messages.includes(:user).order(created_at: :desc)
    @list_messages ||= (@sended_messages + @received_messages).sort_by{|mes| mes.created_at }
  end

  def show
    @recent_conversation = Conversation.includes(:receiver).find(params[:id])
    @sended_messages ||= @recent_conversation.messages.order(created_at: :desc)
    @received_messages ||= Conversation.find_by(sender_id: @recent_conversation.receiver_id, receiver_id: current_user.id).messages.includes(:user).order(created_at: :desc)
    @list_messages ||= (@sended_messages + @received_messages).sort_by{|mes| mes.created_at }
  end

  def update
    @conversation = Conversation.find(params[:id])
    respond_to do |format|
      if @conversation.update_attributes(status: 'readed')
        format.json { render json: {}, status: :ok }
      else
        format.json { render json: @conversation.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_all_conversations
    Conversation.where(id: current_user.conversations).update_all(status: 'read')
    respond_to do |format|
      format.json { render json: {}, status: :ok }
    end
  end

  private
    def message_params
      params.permit(:id)
    end
end
