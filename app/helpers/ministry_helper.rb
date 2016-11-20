module MinistryHelper
  module_function

  # Wraps Formtastic's `form.input :ministry, as: :select` helper, so that our
  # custom jQuery widget can replace the select with a nicer UI widget.
  #
  # @param [Formtastic Form] form DSL
  # @see app/assets/javascripts/ministry/select.coffee
  def select_ministry_widget(form, attribute_name = :ministry)
    form.input(
      attribute_name,
      as: :select,
      collection: Ministry.all.map { |m| [m.to_s, m.id] },
      input_html: {
        'data-ministry-code' => true,
        'data-labels' => Hash[Ministry.all.map { |m| [m.id, m.to_s] }].to_json,
        'data-hierarchy' => ministry_hierarchy.to_json
      }
    )
  end

  # @param [Hash<Ministry, Hash>] the hierarchy to render. If `nil`, will
  #   default to Ministry#hierarchy.
  # @return [Hash<FixNum, Hash] A map of IDs to sub-trees. Each key is the DB
  #   ID of a ministry, and each value is a sub-tree, representing the hierarchy
  #   of ministries "beneath" this one in the organizational structure. That
  #   sub-tree may be empty.
  def ministry_hierarchy(hierarchy = nil)
    hierarchy ||= Ministry.hierarchy

    {}.tap do |h|
      hierarchy.each do |ministry, subtree|
        h[ministry.id] = ministry_hierarchy(subtree)
      end
    end
  end
end
