# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  # GET /users
  def index
    @users = User.all
    render json: @users.to_json(only: %i[id first_name last_name email])
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
    render json: @user.json
  end

  # POST /users
  def create
    @user = User.new(user_params)
    render json: @user.json, status: :created if @user.save!
  end

  # PATCH/PUT /users/1
  def update
    @user = User.find(params[:id])
    render json: @user.json if @user.update!(user_params)
  end

  # DELETE /users/1
  def destroy
    User.find(params[:id]).destroy
  end

  private

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
