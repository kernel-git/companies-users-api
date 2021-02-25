# frozen_string_literal: true

class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, only: %i[show update destroy]

  # GET /companies
  def index
    @companies = Company.all
    render json: @companies
  end

  # GET /companies/1
  def show
    render json: @company
  end

  # POST /companies
  def create
    @company = Company.new(company_params)
    authorize @company
    render json: @company, status: :created if @company.save!
  end

  # PATCH/PUT /companies/1
  def update
    authorize @company
    render json: @company if @company.update!(company_params)
  end

  # DELETE /companies/1
  def destroy
    authorize @company
    @company.destroy
    render status: :no_content if @company.destroyed?
  end

  private

  def set_company
    @company ||= Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(
      :name,
      :description,
      company_user_connections_attributes: %i[
        id
        user_id
        role
        _destroy
      ]
    )
  end
end
