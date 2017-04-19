class ApplicationCell < ArbreCell
  include Rails.application.helpers
  include MoneyRails::ActionViewExtension
  include Pundit

  property :l

  delegates :controller, :current_user

  protected

  def policy(*args)
    if args.any?
      super
    elsif respond_to? :object
      super(object)
    else
      super(controller.resource_class)
    end
  end

  def human_attribute_name(attr_name)
    object.class.human_attribute_name(attr_name)
  end
end
