class BaseController
  attr_reader :request

  def initialize(request)
    @request = request
  end

  private

    def render(body = '', status: 200)
      Rack::Response.new(body, status, 'Content-Type' => 'application/json')
    end

    def params
      request.params
    end

    def body
      @body ||= JSON.parse(request.body.read)
    end
end
