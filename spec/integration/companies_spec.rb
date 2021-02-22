# frozen_string_literal: true

require 'swagger_helper'

describe 'Companies API' do
  path '/companies' do
    get 'Get companies' do
      tags 'Companies'
      produces 'application/json'
      security [{ access_token: [], client: [], uid: [] }]

      response '200', 'multiple companies' do
        schema '$ref': '#/components/schemas/companies'

        before do
          FactoryBot.create(:company)
          FactoryBot.create(:company)
          FactoryBot.create(:company)
        end
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.length).to eq(3)
        end
      end

      response '200', 'single company' do
        schema '$ref': '#/components/schemas/companies'

        before do
          FactoryBot.create(:company)
        end
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.length).to eq(1)
        end
      end

      response '200', 'no companies' do
        schema '$ref': '#/components/schemas/companies'

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.length).to eq(0)
        end
      end
    end

    post 'Creates a company' do
      tags 'Companies'
      consumes 'application/json'
      produces 'application/json'
      security [{ access_token: [], client: [], uid: [] }]
      parameter name: :company, in: :body, schema: { '$ref': '#/components/schemas/new_company' }

      response '201', 'valid request' do
        before do
          FactoryBot.create(:user)
          FactoryBot.create(:user)
        end

        let(:company) do
          {
            company: {
              name: Faker::Lorem.word,
              description: Faker::Lorem.paragraph,
              company_user_connections_attributes: [
                {
                  user_id: 1,
                  role: 'admin'
                },
                {
                  user_id: 1,
                  role: 'manager'
                },
                {
                  user_id: 2,
                  role: 'ceo'
                }
              ]
            }
          }
        end
        run_test!
      end

      response '422', 'invalid user id' do
        let(:company) do
          {
            company: {
              name: Faker::Lorem.word,
              description: Faker::Lorem.paragraph,
              company_user_connections_attributes: [
                {
                  user_id: 1,
                  role: 'admin'
                },
                {
                  user_id: 3000,
                  role: 'manager'
                },
                {
                  user_id: 2,
                  role: 'ceo'
                }
              ]
            }
          }
        end
        run_test!
      end

      response '422', 'invalid request' do
        let(:company) { { description: 'foo' } }
        run_test!
      end
    end
  end

  path '/companies/{id}' do
    get 'Retrieves a company' do
      tags 'Companies'
      produces 'application/json', 'application/xml'
      security [{ access_token: [], client: [], uid: [] }]
      parameter name: :id, in: :path, type: :string

      response '200', 'company found' do
        schema '$ref': '#/components/schemas/company'

        before do
          FactoryBot.create(:user)
          FactoryBot.create(:user)
          FactoryBot.create(:company).company_user_connections.create([
                                                                        { role: 'admin', user_id: 1 },
                                                                        { role: 'manager', user_id: 1 },
                                                                        { role: 'ceo', user_id: 2 }
                                                                      ])
        end

        let(:id) { Company.find(1).id }
        run_test!
      end

      response '404', 'company with invalid id' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    patch 'Updates a company' do
      tags 'Companies'
      produces 'application/json'
      consumes 'application/json'
      security [{ access_token: [], client: [], uid: [] }]
      parameter name: :id, in: :path, type: :string
      parameter name: :company, in: :body, schema: { '$ref': '#/components/schemas/new_company' }

      response 200, 'valid request' do
        schema '$ref': '#/components/schemas/company'

        before do
          FactoryBot.create(:user)
          FactoryBot.create(:user)
          FactoryBot.create(:company).company_user_connections.create([
                                                                        { role: 'admin', user_id: 1 },
                                                                        { role: 'manager', user_id: 1 },
                                                                        { role: 'ceo', user_id: 2 }
                                                                      ])
        end

        let(:id) { Company.find(1).id }
        let(:company) do
          {
            company: {
              name: 'another_name',
              description: 'another_description',
              company_user_connections_attributes: [
                {
                  id: 1,
                  role: 'admin',
                  user_id: 1,
                  _destroy: true
                },
                {
                  id: 2,
                  role: 'manager',
                  user_id: 1
                },
                {
                  id: 3,
                  role: 'janitar',
                  user_id: 2
                }
              ]
            }
          }
        end

        run_test! do |response|
          user_one = User.find(1)
          user_two = User.find(2)
          data = JSON.parse(response.body)
          expect(data).to eq({
            id: 1,
            name: 'another_name',
            description: 'another_description',
            company_user_connections: [
              {
                role: 'manager',
                user: {
                  id: user_one.id,
                  first_name: user_one.first_name,
                  last_name: user_one.last_name,
                  email: user_one.email
                }
              },
              {
                role: 'janitar',
                user: {
                  id: user_two.id,
                  first_name: user_two.first_name,
                  last_name: user_two.last_name,
                  email: user_two.email
                }
              }
            ]
          }.with_indifferent_access)
        end
      end

      response 422, 'invalid company id' do
        schema '$ref': '#/components/schemas/unprocessable_entity'

        before do
          FactoryBot.create(:user)
          FactoryBot.create(:user)
          FactoryBot.create(:company).company_user_connections.create([
                                                                        { role: 'admin', user_id: 1 },
                                                                        { role: 'manager', user_id: 1 },
                                                                        { role: 'ceo', user_id: 2 }
                                                                      ])
        end

        let(:id) { Company.find(1).id }
        let(:company) do
          {
            company: {
              name: 'another_name',
              description: 'another_description',
              company_user_connections_attributes: [
                {
                  id: 1,
                  role: 'admin',
                  user_id: 1,
                  _destroy: true
                },
                {
                  id: 2,
                  role: 'manager',
                  user_id: 3000
                },
                {
                  id: 3,
                  role: 'janitar',
                  user_id: 2
                }
              ]
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['company_user_connections.user']).to include('must exist', 'can\'t be blank')
        end
      end
    end

    delete 'Deletes a company' do
      tags 'Companies'
      produces 'application/json'
      security [{ access_token: [], client: [], uid: [] }]
      parameter name: :id, in: :path, type: :string

      response 204, 'company with valid id' do
        let(:id) { FactoryBot.create(:company).id }
        run_test!
      end

      response 404, 'company with invalid id' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
