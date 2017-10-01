class Router
  def initialize(request)
    @request = request
  end

  def route!
    if (klass = controller_class)
      add_route_info_to_request_params!

      controller = klass.new(@request)
      action = route_info[:action]

      if controller.respond_to?(action)
        return controller.public_send(action)
      end
    end

    not_found
  end

  private

    def not_found
      Rack::Response.new('', 404, 'Content-Type' => 'application/json')
    end

    def add_route_info_to_request_params!
      @request.params.merge!(route_info)
    end

    def route_info
      @route_info ||= begin
        resource = path_fragments[0] || 'base'
        id, action = find_id_and_action(path_fragments[1])
        { resource: resource, action: action, id: id }
      end
    end

    def find_id_and_action(fragment)
      case fragment
        when 'new'
          [nil, :new]
        when nil
          action = @request.get? ? :index : :create
          [nil, action]
        else
          action = @request.get? ? :show : :update
          [fragment, action]
      end
    end

    def path_fragments
      @fragments ||= @request.path.split('/').reject { |s| s.empty? }
    end

    def controller_name
      "#{route_info[:resource].capitalize}Controller"
    end

    def controller_class
      Object.const_get(controller_name)
    rescue NameError
      nil
    end
end
