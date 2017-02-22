class ApplicationCell < Cell::ViewModel
  include Rails.application.helpers

  property :l

  protected

  def model_exec(&block)
    model.instance_exec(&block)
  end
end
