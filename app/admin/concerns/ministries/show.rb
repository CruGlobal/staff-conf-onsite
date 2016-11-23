module Ministries
  module Show
    def self.included(base)
      base.send :show do
        columns do
          column do
            instance_exec(&AttributesTable)
          end

          column do
            if ministry.ancestors.any? || ministry.children.any?
              instance_exec(&MinistryHierarchy)
            end

            instance_exec(&MembersPanel)
          end
        end
      end
    end

    MembersPanel = proc do
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

    MinistryHierarchy = proc do
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

    AttributesTable = proc do
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
