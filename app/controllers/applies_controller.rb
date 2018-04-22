class AppliesController < ApplicationController
  before_action :set_apply, only: [:show, :edit, :update, :destroy]

  def create
    @apply = Apply.new(apply_params)

    respond_to do |format|
      if @apply.save
        format.html { redirect_to @apply, notice: 'Apply was successfully created.' }
        format.json { render :show, status: :created, location: @apply }
      else
        format.html { render :new }
        format.json { render json: @apply.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @apply.destroy
    respond_to do |format|
      format.html { redirect_to applies_url, notice: 'Apply was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def apply_params
      params.require(:apply).permit(:create, :destroy)
    end
end
