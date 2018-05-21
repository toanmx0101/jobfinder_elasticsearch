class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:create]

  def index
    @messages = Message.all
  end

  def show; end

  def new
    @message = Message.new
  end

  def edit; end

  def create
    @message = current_user.messages.build(message_params)
    @message.message_type = :normal
    respond_to do |format|
      if @message.save
        @message.conversation.update_attributes(status: 'unread')
        format.html { redirect_to @message, notice: 'Message was successfully created.' }
        format.json { render json: {},status: :created }
      else
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.permit(:content, :conversation_id)
    end
end
