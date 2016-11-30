module Ministries
  # Defines the HTML for rendering a single {Ministry} record.
  module Show
    def self.included(base)
      base.send :show do
        columns do
          column do
            instance_exec(&ATTRIBUTES_TABLE)
          end

          column do
            if ministry.ancestors.any? || ministry.children.any?
              instance_exec(&MINISTRY_HIERARCHY)
            end

            instance_exec(&MEMBERS_PANEL)
          end
        end
      end
    end

    MEMBERS_PANEL ||= proc do
      num_members = ministry.people.size

      panel "Members (#{num_members})" do
        if num_members.positive?
          ul do
            ministry.people.each do |p|
              li { link_to(p.full_name, p) }
            end
          end
        else
          strong 'None'
        end
      end
    end

    MINISTRY_HIERARCHY ||= proc do
      panel 'Hierarchy' do
        div class: 'ministry__hierarchy' do
          if ministry.ancestors.any?
            ul class: 'ministry__hierarchy__ancestors' do
              ministry.ancestors.each do |m|
                li(class: 'ministry__hierarchy__ancestor') { link_to m, m }
              end
            end
          end

          div(class: 'ministry__hierarchy__this') { ministry }

          if ministry.children.any?
            ul class: 'ministry__hierarchy__children' do
              ministry.children.each do |child|
                li class: 'ministry__hierarchy__child' do
                  link_to child, child
                end
              end
            end
          end
        end
      end
    end

    ATTRIBUTES_TABLE ||= proc do
      attributes_table do
        row :id
        row :code
        row :name
        row(:parent) do |m|
          link_to m.parent, m.parent if m.parent.present?
        end
        row :created_at
        row :updated_at
      end

      active_admin_comments
    end
  end
end
