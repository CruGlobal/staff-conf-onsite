if Rails.env.development? || Rails.env.testing?
  StubCas.stub_requests
end
