module PaperTrail
  # The security policy for accessing {VersionPolicy} records.
  class VersionPolicy < AdminOnlyPolicy
    def create?
      false # these should be managed by PaperTrail
    end

    def update?
      false # these should be managed by PaperTrail
    end
  end
end
