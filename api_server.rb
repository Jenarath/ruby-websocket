require 'sinatra'
require 'json'

class APIServer < Sinatra::Base
  get '/' do
    'Hello, world!'
  end

  get '/api/v1/resource' do
    content_type :json
    { message: 'This is a GET request' }.to_json
  end

  post '/api/v1/resource' do
    content_type :json
    request_body = JSON.parse(request.body.read)
    { message: 'This is a POST request', data: request_body }.to_json
  end

  put '/api/v1/resource/:id' do
    content_type :json
    request_body = JSON.parse(request.body.read)
    { message: "This is a PUT request for resource #{params['id']}", data: request_body }.to_json
  end

  delete '/api/v1/resource/:id' do
    content_type :json
    { message: "This is a DELETE request for resource #{params['id']}" }.to_json
  end
end

# Start the API server
APIServer.run!