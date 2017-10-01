class SolutionsController < BaseController
  LANGUAGES = %w(ruby python python3 nodejs).freeze

  def create
    code = body['code']
    language = body['language']
    if LANGUAGES.include?(language)
      uuid = SecureRandom.uuid
      File.write("store/code/#{uuid}", code)
      time, logs, errors = %x(lib/runner.sh #{uuid} #{language}).split('*****').map(&:strip)
      debug(uuid, code, time, logs, errors) unless ENV['RACK_ENV'] == 'production'
      status = ((time != '-1') && errors.empty?) ? 200 : 400
      render({ logs: logs, errors: errors, time: time }.to_json, status: status)
    else
      render('', status: 400)
    end
  end

  private

    def debug(uuid, code, time, logs, errors)
      puts '*** FILES ***'
      puts uuid
      puts '*** CODE ***'
      puts code
      puts '*** EXECUTION TIME ***'
      puts time
      puts '*** RUNTIME LOGS ***'
      puts logs
      puts '*** RUNTIME ERRORS ***'
      puts errors
    end
end
