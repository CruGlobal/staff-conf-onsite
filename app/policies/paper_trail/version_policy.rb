module PaperTrail
  class VersionPolicy < ReadOnlyPolicy
    def create?
      false # these should be managed by PaperTrail
    end

    def update?
      false # these should be managed by PaperTrail
    end
  end
end
