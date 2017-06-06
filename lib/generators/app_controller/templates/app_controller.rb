<<-CODE
class ApplicationController < ActionController::API

    def authorize_request
        return unauthorized_response if request.headers['Authorization'].blank?

        url = Rails.configuration.permissions_url

        if !(url =~ /^http.*/)
            url = "http://\#{url}"
        end
        
        connection = Faraday.new(url: url) do |faraday|
            faraday.request :url_encoded
            faraday.adapter Faraday.default_adapter
        end

        response = connection.get do |req|
            req.headers['Authorization'] = request.headers['Authorization'].split(' ').last
            req.params['operation'] = params['action']
            req.params['resource'] = params['controller']
        end

        body = JSON.parse(response.body) rescue {}

        return unauthorized_response if response.status != 200 || (body['authorized'] != true)
    end

    private

    def unauthorized_response
        render json: {errors: ['You are not authorized']}, status: :unauthorized
    end
    
end

CODE