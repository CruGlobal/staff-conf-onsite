require 'tmpdir'

# Provides the status of an upload job running in the background, so that we
# can update the user-agent with its progress.
#
# It's possible that an uploaded file will have to be uploaded in multple
# steps, so an upload's job has multiple "stages", each of which will move its
# "percentage" from 0.0 to 1.0. So it is possible for {#percentage} to be +1.0+
# without the job being {#finished}
class UploadJob < ActiveRecord::Base
  scope :done,      -> { where(percentage: 1) }
  scope :succeeded, -> { where(success: true) }
  scope :failed,    -> { where(success: false) }

  belongs_to :user

  validates :path, :stage, :percentage, presence: true

  class << self
    def create_with_copy!(attributes = {})
      old_path = attributes.fetch(:path)
      attributes[:path] = copy_name(old_path)
      FileUtils.cp(old_path, attributes[:path])

      create!(attributes)
    end

    private

    def copy_name(old_path)
      filename = File.basename(old_path)
      File.join(temp_dir, filename)
    end

    def temp_dir
      @temp_dir ||=
        Dir.mktmpdir('upload_job').tap do |dir|
          at_exit { FileUtils.remove_entry(dir) }
        end
    end
  end

  def success=(success)
    super
    self.finished = true
  end

  def finished=(finish)
    super
    self.percentage = 1.0
  end

  def stage=(name)
    super
    self.percentage = 0.0
  end

  def percentage=(value)
    v = value.to_f
    super([0.0, [v, 1.0].min].max)
  end

  def file
    @file ||= open(path, File::RDONLY)
  end

  def unlink_file!
    File.unlink(path) if File.exist?(path)
  end

  def as_json(*_args)
    super.tap { |json| json.delete('path') }
  end
end
