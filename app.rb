Dir.glob(File.expand_path('../app/**/*.rb', __FILE__)).each { |f| require(f) }
require 'json'

class Evaluator
  def self.app
    Rack::Builder.new do
      run Evaluator.new
    end
  end

  def call(env)
    request = Rack::Request.new(env)
    Router.new(request).route!
  end
end
