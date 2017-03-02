class PaperTrailVersion::ShowCell < ::ShowCell
  property :paper_trail_version

  def show
    columns do
      column { version_attributes_table }
      column { previous_versions_panel }
    end

    active_admin_comments
  end

  private

  def version_attributes_table
    attributes_table do
      row :id
      row('Record') { |v| version_label(v) }
      row :event
      row('When')   { |v| v.created_at.to_s :long }
      row('Editor') { |v| editor_link(v) }
    end
  end

  def previous_versions_panel
    panel 'Previous Version Details' do
      obj = previous_version_hash(paper_trail_version)

      if obj.any?
        previous_versions_table(obj)
      else
        strong 'This is the first version of the record.'
      end
    end
  end

  def previous_versions_table(obj)
    table do
      thead do
        tr do
          th 'Attribute'
          th 'Value'
        end
      end

      tbody do
        obj.each { |key, value| previous_version_row(key, value) }
      end
    end
  end

  def previous_version_row(key, value)
    tr do
      td strong key.humanize
      td do
        case key
        when 'description'
          html_full(value)
        else
          value
        end
      end
    end
  end
end
