class AggregatePdfService < PdfService
  DEFAULT_KEY = :record

  attr_accessor :service
  attr_accessor :collection
  attr_accessor :options
  attr_accessor :key

  def initialize(service, collection, opts = {})
    self.service = service
    self.collection = collection
    self.key = opts.delete(:key) || DEFAULT_KEY
    self.options = opts

    super({})
  end

  def call
    if collection.any?
      render_collection
    else
      text 'No records found.'
    end
  end

  private

  def render_collection
    collection.each_with_index do |record, index|
      start_new_page unless index.zero?
      service.call(options.merge(key => record, document: document))
    end
  end
end
