module ActiveAdmin
  module Comments
    # Adds #active_admin_comments to the edit page for use and sets it up on
    # the main content
    module EditPageHelper
      def self.prepended(base)
        base.class_eval do
          alias_method :main_content_without_comments, :main_content
          alias_method :main_content, :main_content_with_comments
        end
      end

      # Add admin comments to the main content if they are
      # turned on for the current resource
      def main_content_with_comments
        main_content_without_comments
        active_admin_comments_for(resource) if active_admin_config.comments?
      end
    end
  end
end