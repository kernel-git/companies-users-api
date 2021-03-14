# frozen_string_literal: true

require 'swagger_helper'

describe 'Users API' do
  path '/users' do
    get 'Get users' do
      tags 'Users'
      produces 'application/json'
      security [{ access_token: [], client: [], uid: [] }]

      response '200', 'multiple users' do
        schema '$ref': '#/components/schemas/users'

        before do |_example|
          User.create(
            [{
              first_name: 'first_name',
              last_name: 'last_name',
              email: 'testemail@example.com',
              password: '11111111',
              password_confirmation: '11111111'
            },
             {
               first_name: 'another_first_name',
               last_name: 'another_last_name',
               email: 'anotheremail@example.com',
               password: '11111111',
               password_confirmation: '11111111'
             }]
          )
        end
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.length).to eq(2)
        end
      end

      response '200', 'single user' do
        schema '$ref': '#/components/schemas/users'

        before do
          User.create({
                        first_name: 'first_name',
                        last_name: 'last_name',
                        email: 'testemail@example.com',
                        password: '11111111',
                        password_confirmation: '11111111'
                      })
        end
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.length).to eq(1)
        end
      end

      response '200', 'no users' do
        schema '$ref': '#/components/schemas/users'

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.length).to eq(0)
        end
      end
    end

    post 'Creates a user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      security [{ access_token: [], client: [], uid: [] }]
      parameter name: :user, in: :body, schema: { '$ref': '#/components/schemas/new_user' }

      response '201', 'valid request' do
        before do
          Company.create([
                           {
                             name: 'CompanyOne',
                             description: 'description'
                           },
                           {
                             name: 'CompanyTwo',
                             description: 'description'
                           }
                         ])
        end

        let(:user) do
          {
            user: {
              first_name: 'first_name',
              last_name: 'last_name',
              email: 'testemail@example.com',
              password: '11111111',
              password_confirmation: '11111111',
              company_user_connections_attributes: [
                {
                  company_id: 1,
                  role: 'admin'
                },
                {
                  company_id: 1,
                  role: 'manager'
                },
                {
                  company_id: 2,
                  role: 'ceo'
                }
              ]
            }
          }
        end
        run_test!
      end

      response '422', 'invalid company id' do
        let(:user) do
          {
            user: {
              first_name: 'first_name',
              last_name: 'last_name',
              email: 'testemail@example.com',
              password: '11111111',
              password_confirmation: '11111111',
              company_user_connections_attributes: [
                {
                  company_id: 1,
                  role: 'admin'
                },
                {
                  company_id: 3000,
                  role: 'manager'
                },
                {
                  company_id: 2,
                  role: 'ceo'
                }
              ]
            }
          }
        end
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { { first_name: 'foo' } }
        run_test!
      end
    end
  end

  path '/users/{id}' do
    get 'Retrieves a user' do
      tags 'Users'
      produces 'application/json', 'application/xml'
      security [{ access_token: [], client: [], uid: [] }]
      parameter name: :id, in: :path, type: :string

      response '200', 'user found' do
        schema '$ref': '#/components/schemas/user'

        let(:id) do
          User.create(
            first_name: 'first_name',
            last_name: 'last_name',
            email: 'testemail@example.com',
            password: '11111111',
            password_confirmation: '11111111'
          ).id
        end
        run_test!
      end

      response '404', 'user with invalid id' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    patch 'Updates a user' do
      tags 'Users'
      produces 'application/json'
      consumes 'application/json'
      security [{ access_token: [], client: [], uid: [] }]
      parameter name: :id, in: :path, type: :string
      parameter name: :user, in: :body, schema: { '$ref': '#/components/schemas/new_user' }

      response 200, 'valid request' do
        schema '$ref': '#/components/schemas/user'

        before do
          FactoryBot.create(:company)
          FactoryBot.create(:company)
          FactoryBot.create(:user).company_user_connections.create([
                                                                     { role: 'admin', company_id: 1 },
                                                                     { role: 'manager', company_id: 1 },
                                                                     { role: 'ceo', company_id: 2 }
                                                                   ])
        end

        let(:id) { User.find(1).id }
        let(:user) do
          {
            user: {
              first_name: 'another_first_name',
              last_name: 'last_name',
              email: 'anotheremail@example.com',
              password: '11111111',
              password_confirmation: '11111111',
              company_user_connections_attributes: [
                {
                  id: 1,
                  role: 'admin',
                  company_id: 1,
                  _destroy: true
                },
                {
                  id: 2,
                  role: 'manager',
                  company_id: 1
                },
                {
                  id: 3,
                  role: 'janitar',
                  company_id: 2
                }
              ]
            }
          }
        end

        run_test! do |response|
          company_one = Company.find(1)
          company_two = Company.find(2)
          data = JSON.parse(response.body)
          expect(data).to eq({
            id: 1,
            first_name: 'another_first_name',
            last_name: 'last_name',
            email: 'anotheremail@example.com',
            company_user_connections: [
              {
                role: 'manager',
                company: {
                  id: company_one.id,
                  name: company_one.name,
                  description: company_one.description
                }
              },
              {
                role: 'janitar',
                company: {
                  id: company_two.id,
                  name: company_two.name,
                  description: company_two.description
                }
              }
            ]
          }.with_indifferent_access)
        end
      end

      response 422, 'invalid company id' do
        schema '$ref': '#/components/schemas/unprocessable_entity'

        before do
          FactoryBot.create(:company)
          FactoryBot.create(:company)
          FactoryBot.create(:user).company_user_connections.create([
                                                                     { role: 'admin', company_id: 1 },
                                                                     { role: 'manager', company_id: 1 },
                                                                     { role: 'ceo', company_id: 2 }
                                                                   ])
        end

        let(:id) { User.find(1).id }
        let(:user) do
          {
            user: {
              first_name: 'another_first_name',
              last_name: 'last_name',
              email: 'anotheremail@example.com',
              password: '11111111',
              password_confirmation: '11111111',
              company_user_connections_attributes: [
                {
                  id: 1,
                  role: 'admin',
                  company_id: 1,
                  _destroy: true
                },
                {
                  id: 2,
                  role: 'manager',
                  company_id: 3000
                },
                {
                  id: 3,
                  role: 'janitar',
                  company_id: 2
                }
              ]
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['company_user_connections.company']).to include('must exist', 'can\'t be blank')
        end
      end

      response 422, 'invalid email' do
        schema '$ref': '#/components/schemas/unprocessable_entity'

        let(:id) { FactoryBot.create(:user).id }
        let(:user) do
          {
            user: {
              first_name: 'another_first_name',
              last_name: 'last_name',
              email: 'invalid',
              password: '11111111',
              password_confirmation: '11111111'
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['email']).to include('is not a valid email')
        end
      end
    end

    delete 'Deletes a user' do
      tags 'Users'
      produces 'application/json'
      security [{ access_token: [], client: [], uid: [] }]
      parameter name: :id, in: :path, type: :string

      response 204, 'user with valid id' do
        let(:id) do
          User.create(
            first_name: 'first_name',
            last_name: 'last_name',
            email: 'testemail@example.com',
            password: '11111111',
            password_confirmation: '11111111'
          ).id
        end
        run_test!
      end

      response 404, 'user with invalid id' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
