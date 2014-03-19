module Api::Public::V1
  VERSION   = Gem::Version.new("0.1.0")

  class BaseController < ::ActionController::Base
    respond_to :json

    def options
      allow_origin
      head :ok
    end


    private

    def allow_origin
      response.headers.merge!({
        "Access-Control-Allow-Origin"   => request.headers['Origin'],
        "Access-Control-Allow-Methods"  => "GET, OPTIONS",
        "Access-Control-Request-Method" => "GET",
        "Access-Control-Allow-Headers"  => "Origin, X-Requested-With, Content-Type"
      })
    end


    def render_not_found(options={})
      message = options[:message] || "Not Found"
      render status: :not_found, json: { error: message }
    end


    def render_bad_request(options={})
      message = options[:message] || "Bad Request"
      render status: :bad_request, json: { error: message }
    end


    def render_unauthorized(options={})
      message = options[:message] || "Unauthorized"
      render status: :unauthorized, json: { error: message }
    end
  end
end
