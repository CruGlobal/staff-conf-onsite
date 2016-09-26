require 'test_helper'

class CasAttributesTest < ActiveSupport::TestCase
  setup do
    stub_request(
      :get,
      'https://thekey.me/cas/api/test/user/attributes?email=bob@example.com'
    )
      .with(headers: {'Accept' => 'application/json'})
      .to_return(
        status: 200,
        body: %(
          {
            "relayGuid": "8F612500-0000-541D-FC38-2AF75974729F",
            "ssoGuid": "8F612500-0000-541D-FC38-2AF75974729F",
            "firstName": "Test",
            "lastName": "user",
            "theKeyGuid": "8F612500-0000-541D-FC38-2AF75974729F",
            "email": "bob@example.com"
          }
        ),
        headers: {}
      )
  end

  def test_get
    user = CasAttributes.new('bob@example.com')
    assert_equal '8F612500-0000-541D-FC38-2AF75974729F', user.get['ssoGuid']
  end
end
