# Based on
# github.com/CruGlobal/global360/blob/master/app/services/key_services/user.rb
class CasAttributes
  attr_accessor :email

  def initialize(email)
    self.email = email
  end

  # Sample output
  # {"relayGuid"=>"F167605D-94A4-7121-2A58-8D0F2CA6E026",
  #  "ssoGuid"=>"F167605D-94A4-7121-2A58-8D0F2CA6E026",
  #  "firstName"=>"Joshua",
  #  "lastName"=>"Starcher",
  #  "theKeyGuid"=>"F167605D-94A4-7121-2A58-8D0F2CA6E026",
  #  "email"=>"josh.starcher@cru.org"}
  def get
    JSON.parse(
      RestClient.get(
        "#{base_url}/user/attributes?email=#{CGI.escape(email)}",
        accept: :json
      )
    )
  end

  def base_url
    "#{ENV['CAS_URL']}/api/#{ENV['CAS_ACCESS_TOKEN']}"
  end
end
