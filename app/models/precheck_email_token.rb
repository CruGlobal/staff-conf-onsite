class PrecheckEmailToken < ApplicationRecord
  self.primary_key = 'token'

  belongs_to :family

  validates :token, presence: true, uniqueness: true
  validates :family, presence: true, uniqueness: { message: 'Family already has a precheck email token' }

  after_initialize do
    self.token = generate_token if token.blank?
  end

  private

  def generate_token
    SecureRandom.urlsafe_base64(16)
  end
end
