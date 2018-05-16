class ConversationsController < ApplicationController
  before_action :authenticate_user!, only: [:update]

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
  private
    def message_params
      params.permit(:id)
    end
end
