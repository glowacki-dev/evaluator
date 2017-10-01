require_relative 'app'

use Rack::Reloader, 0
run Evaluator.app
