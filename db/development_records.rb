# The +dev:populate+ rake tasks will generate plenty of random data to test
# your development code against, but this class will create some non-random
# records which may be helpful.
class SeedDevelopmentRecords
  include FactoryGirl::Syntax::Methods

  # These courses are referenced by some test spreadsheet imports found in
  # +test/fixtures/+
  COURSES = [
    'Apologetics',
    'Biblical Communication',
    'Biblical Interpretation',
    'Christian Worldview',
    'Church History',
    'God / Bible / Holy Spirit',
    'Humanity / Christ / Salvation',
    'Old Testament Survey'
  ].freeze

  # These conferences are referenced by some test spreadsheet imports found in
  # +test/fixtures/+
  CONFERENCES = [
    'Cru17',
    'Legacy Track (Staff 60 years of age and older)',
    'Missional Team Leader Spouse',
    'Missional Team Leader Training Participant',
    'Other'
  ].freeze

  def initialize
    FactoryGirl.find_definitions
  end

  def call
    create_users
    create_courses
    create_conferences
  end

  private

  def create_users
    # Example role accounts
    User.create!(role: 'admin', email: 'jon.sangster+admin@ballistiq.com')
    User.create!(role: 'finance', email: 'jon.sangster+finance@ballistiq.com')
    User.create!(role: 'general', email: 'jon.sangster+general@ballistiq.com')

    # Developer accounts
    User.create!(role: 'admin', email: 'jon.sangster@ballistiq.com')
    User.create!(role: 'admin', email: 'tyler@ballistiq.com')
    User.create!(role: 'admin', email: 'daniel.fugere@ballistiq.com')
  end

  def create_courses
    COURSES.each { |name| create :course, name: name }
  end

  def create_conferences
    CONFERENCES.each { |name| create :conference, name: name }
  end
end
