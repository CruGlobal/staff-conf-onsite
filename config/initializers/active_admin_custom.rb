# This initializer includes ActiveAdmin customization beyond the out-of-the-box
# configuration.

# Add extra buttons to the #show page
ActiveAdmin::Resource.include(ActiveAdmin::Resource::AdditionalActionItems)

# Show comments form on #edit pages too
require 'active_admin/comments/edit_page_helper'
ActiveAdmin.application.view_factory.edit_page.send(
  :include, ActiveAdmin::Comments::EditPageHelper
)
