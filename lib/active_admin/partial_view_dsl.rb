module ActiveAdmin
  class PartialViewDSL
    def self.create_actions(dsl, actions)
      new(dsl).tap do |view_dsl|
        actions.each do |action|
          if action.is_a?(Hash)
            action.each { |a, opts| view_dsl.add_view(a, opts) }
          else
            view_dsl.add_view(action)
          end
        end
      end
    end

    def initialize(dsl)
      @dsl = dsl
    end

    def add_view(action, options = nil)
      action = action.to_s
      partial = format('%s/%s', view_prefix, action)
      options = wrap_options(options)

      if action == 'form'
        @dsl.send(action.to_sym, *options) { |f| render partial, context: f }
      else
        @dsl.send(action.to_sym, *options) { render partial, context: self }
      end
    end

    def wrap_options(options)
      if options.is_a?(Hash)
        [options]
      else
        Array(options)
      end
    end

    def view_prefix
      @dsl.config.resource_name.route_key
    end
  end
end
