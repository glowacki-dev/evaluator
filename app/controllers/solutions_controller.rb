require_relative 'base_controller'

class SolutionsController < BaseController
  LANGUAGES = %w(ruby python python3 nodejs).freeze

  def show
    uuid = params[:id]
    if Dir.exist? "store/#{uuid}"
      if File.exist? "store/#{uuid}/time"
        output = File.read("store/#{uuid}/output").strip
        errors = File.read("store/#{uuid}/errors").strip
        time = File.read("store/#{uuid}/time").strip
        debug(output: output, errors: errors, time: time) unless ENV['RACK_ENV'] == 'production'
        render({ ready: true, output: output, errors: errors, time: time.to_i }.to_json)
      else
        render({ ready: false }.to_json)
      end
    else
      render(status: 404)
    end
  end

  def create
    if create_params_valid?
      uuid = SecureRandom.uuid
      code = body['code']
      debug(uuid: uuid, code: code) unless ENV['RACK_ENV'] == 'production'
      File.write("store/code/#{uuid}", code)
      Process.detach(spawn(magic_spell(uuid)))
      render({ id: uuid }.to_json)
    else
      render(status: 400)
    end
  end

  private

    def debug(**params)
      params.each do |k, v|
        puts "*** #{k.to_s.upcase} ***"
        puts v
      end
      puts '*** DONE ***'
    end

    def create_params_valid?
      LANGUAGES.include?(body['language']) &&
        body['timeout'] =~ /\A\d+\z/ &&
        body['memory'] =~ /\A\d+[bkmg]\z/ &&
        body['cpus'] =~ /\A\d*(\.\d+)?\z/
    end

    def magic_spell(uuid)
      "lib/runner.sh #{uuid} #{body['language']} #{body['timeout']} #{body['memory']} #{body['cpus']}"
    end
end
