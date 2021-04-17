# frozen_string_literal: true

class V1::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show update destroy]

  # GET /users
  def index
    @users = User.all
    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)
    render json: @user, status: :created if @user.save!
  end

  # PATCH/PUT /users/1
  def update
    render json: @user if @user.update!(user_params)
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    render status: :no_content if @user.destroyed?
  end

  private

  def set_user
    @user ||= User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :password,
      :password_confirmation,
      company_user_connections_attributes: %i[
        id
        company_id
        role
        _destroy
      ]
    )
  end
end
