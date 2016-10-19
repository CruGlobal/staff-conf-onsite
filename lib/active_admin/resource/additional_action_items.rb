module ActiveAdmin
  class Resource
    # @see https://github.com/activeadmin/activeadmin/blob/master/lib/active_admin/resource/action_items.rb
    module AdditionalActionItems
      def initialize(*args)
        add_additional_action_items
        super
      end

      private

      def add_additional_action_items
        add_additional_new_action_item
      end

      # Adds the default New link on :show. Normally it's only on :index.
      def add_additional_new_action_item
        add_action_item :new_show, only: :show do
          permitted =
            authorized? ActiveAdmin::Auth::CREATE,
                        active_admin_config.resource_class

          if controller.action_methods.include?('new') && permitted
            link_to(
              I18n.t(
                'active_admin.new_model',
                model: active_admin_config.resource_label
              ),
              new_resource_path
            )
          end
        end
      end
    end
  end
end
