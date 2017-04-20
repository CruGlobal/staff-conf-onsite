class ArbreCell < Cell::ViewModel
  property :build_tag, :insert_tag, :text_node

  (Arbre::HTML::AUTO_BUILD_ELEMENTS + [:para] - [:object]).each do |elem|
    property elem
  end

  # The +Arbre+ method {#object} conflicts with a pre-existing +Cell+ method
  def object_element
    model.object
  end

  def new_arbre_context(&blk)
    Arbre::Context.new(receiver: self) { receiver.instance_exec(&blk) }
  end

  def call(state = :show, *args, &block)
    render_state(state, *args, &block)

    # we return +nil+ to avoid rending the elements twice.  Arbre inserts HTML
    # into a {Arbre::Context}, but also returns the HTML from method call.
    # If a builder method returns a string, it will be appended to the page a
    # second time.
    nil
  end
end
