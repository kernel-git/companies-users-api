# frozen_string_literal: true

class CompaniesController < ApplicationController
  before_action :authenticate_user!

  # GET /companies
  def index
    @companies = Company.all
    render json: @companies.to_json(only: %i[id name description], include: {
                                      company_user_connections: {
                                        only: :role, include: {
                                          user: { only: %i[id first_name last_name email] }
                                        }
                                      }
                                    })
  end

  # GET /companies/1
  def show
    @company = Company.find(params[:id])
    render json: @company.json
  end

  # POST /companies
  def create
    @company = Company.new(company_params)
    authorize @company
    render json: @company.json, status: :created if @company.save!
  end

  # PATCH/PUT /companies/1
  def update
    @company = Company.find(params[:id])
    authorize @company
    render json: @company.json if @company.update!(company_params)
  end

  # DELETE /companies/1
  def destroy
    @company = Company.find(params[:id])
    authorize @company
    @company.destroy
  end

  private

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
