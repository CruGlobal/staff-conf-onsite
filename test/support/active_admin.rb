module Support
  module ActiveAdmin
    def assert_index_columns(*cols)
      within('.index_table thead') do
        cols.each { |col| assert_selector ".col-#{col}" }
      end
    end

    def assert_show_rows(*rows, selector: nil)
      within("#{selector}.attributes_table") do
        rows.each { |row| assert_selector ".row-#{row}"}
      end
    end

    def assert_edit_fields(*fields, record:)
      within("form#edit_#{form_name(record)}") do
        fields.each do |f|
          assert_selector(
            %w(input select textarea).
              map { |elem| "#{elem}##{form_name(record)}_#{f}" }.
              join(', ')
          )
        end
      end
    end

    def assert_active_admin_comments
      assert_selector 'form.active_admin_comment'
    end

    private

    def form_name(obj)
      case obj
      when String then obj
      when ActiveRecord::Base then obj.class.to_s.underscore
      else obj.to_s.underscore
      end
    end
  end
end
