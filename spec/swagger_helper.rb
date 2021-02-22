# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: 'http://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'localhost:3000'
            }
          }
        }
      ],
      components: {
        securitySchemes: {
          access_token: {
            type: :apiKey,
            name: 'access_token',
            in: :header
          },
          client: {
            type: :apiKey,
            name: 'client',
            in: :header
          },
          uid: {
            type: :apiKey,
            name: 'uid',
            in: :header
          }
        },
        schemas: {
          user: {
            type: :object,
            properties: {
              id: { type: :integer },
              first_name: { type: :string },
              last_name: { type: :string },
              email: { type: :string }
            },
            required: %w[id first_name last_name email]
          },
          users: {
            type: :array,
            items: {
              properties: {
                id: { type: :integer },
                first_name: { type: :string },
                last_name: { type: :string },
                email: { type: :string }
              },
              required: %w[id first_name last_name email]
            }
          },
          new_user: {
            type: :object,
            properties: {
              user:
              {
                type: :object,
                properties: {
                  first_name: { type: :string },
                  last_name: { type: :string },
                  email: { type: :string },
                  password: { type: :string },
                  password_confirmation: { type: :string },
                  company_user_connections_attributes: {
                    type: :array,
                    items: {
                      type: :object,
                      properties: {
                        role: { type: :string },
                        company_id: { type: :integer }
                      }
                    }
                  }
                }
              }
            },
            required: %w[first_name last_name email password password_confirmation]
          },
          company: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              description: { type: :string }
            },
            required: %w[id name]
          },
          companies: {
            type: :array,
            items: {
              properties: {
                id: { type: :integer },
                name: { type: :string },
                description: { type: :string }
              },
              required: %w[id name]
            }
          },
          new_company: {
            type: :object,
            properties: {
              company:
              {
                type: :object,
                properties: {
                  name: { type: :string },
                  description: { type: :string }
                }
              }
            },
            required: :name
          },
          unprocessable_entity: {
            type: :object,
            properties: {
              first_name: { type: :array },
              last_name: { type: :array },
              email: { type: :array },
              password: { type: :array },
              password_confirmation: { type: :array }
            }
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml
end
