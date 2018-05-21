class ConversationsController < ApplicationController
  before_action :authenticate_user!, only: [:update, :update_all_conversations]

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
