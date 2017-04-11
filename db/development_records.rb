# The +dev:populate+ rake tasks will generate plenty of random data to test
# your development code against, but this class will create some non-random
# records which may be helpful.
class SeedDevelopmentRecords
  include FactoryGirl::Syntax::Methods

  # These courses are referenced by some test spreadsheet imports found in
  # +test/fixtures/+
  COURSES = [
    'Apologetics',
    'Bible Study Methods',
    'Biblical Communication',
    'Biblical Interpretation',
    'Christian Worldview',
    'Church History',
    'God / Bible / Holy Spirit',
    'Humanity / Christ / Salvation',
    'Intro to Christian Theology',
    'Intro to Mission',
    'Intro to Mission (online course for New Staff only)',
    'Old Testament Survey'
  ].freeze

  # These conferences are referenced by some test spreadsheet imports found in
  # +test/fixtures/+
  CONFERENCES = [
    'Coach or Instructor',
    'Cru17',
    'Institute of Biblical Studies TA',
    'Legacy Track (Staff 60 years of age and older)',
    'Legal Internship Participant',
    'Missional Team Leader Spouse',
    'Missional Team Leader Training Coach or Design Team Member',
    'Missional Team Leader Training Participant',
    'MPD Training: Married New Staff & Spouse is Not Attending',
    'MPD Training: Married New Staff & Spouse is NS or SA and Attending MPD',
    'MPD Training: Married New Staff & Spouse is Senior Staff',
    'MPD Training: Senior Staff',
    'MPD Training: Single',
    'New Staff Orientation',
    'New Staff Training',
    'Other',
    'StillWaters17',
    'XTrack Participant',
    'XTrack Training Team'
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
