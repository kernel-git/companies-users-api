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
    if @company.save
      render json: @company.json, status: :created
    else
      render json: @company.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /companies/1
  def update
    @company = Company.find(params[:id])
    authorize @company
    if @company.update(company_params)
      render json: @company.json
    else
      render json: @company.errors, status: :unprocessable_entity
    end
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
