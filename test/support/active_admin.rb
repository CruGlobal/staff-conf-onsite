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

    # Used to fill ckeditor fields
    # @param [String] locator label text for the textarea or textarea id
    def fill_in_ckeditor(locator, with:)
      if page.has_css?('label', text: locator)
        locator = find('label', text: locator)[:for]
      end

      # Fill the editor content
      page.execute_script <<-SCRIPT
         var ckeditor = CKEDITOR.instances.#{locator}
         ckeditor.setData('#{with}')
         ckeditor.focus()
         ckeditor.updateElement()
      SCRIPT
    end

    # Selects a random <option>
    # @param [String] selector
    # @param [Boolean] include_blank +true+ to not randomly choose the blank
    #   option
    def select_random(selector, include_blank: false)
      select = find_field(selector, visible: false)
      options = select.all('option', visible: false)

      if (chosen = chosen_widget_sibling(select))
        blank_index =
          if include_blank
            nil
          else
            options.index(options.find { |opt| opt['value'].blank? })
          end

        chosen_widget_select_random(chosen, blank_index: blank_index)
      else
        options[rand(options.size)].select_option
      end
    end

    # @param [Fixnum] blank_index The index of the blank option, which will
    #   not be chosen. +nil+ to choose any option
    def chosen_widget_select_random(element, blank_index: nil)
      element.click

      options = element.all('.active-result').to_a
      options.delete_at(blank_index) if blank_index.present?

      options[rand(options.size)].click
    end

    private

    def chosen_widget_sibling(element)
      if (parent = element.first(:xpath, './/..'))
        parent.find('.chosen-container')
      end
    end

    def form_name(obj)
      case obj
      when String then obj
      when ActiveRecord::Base then obj.class.to_s.underscore
      else obj.to_s.underscore
      end
    end
  end
end
