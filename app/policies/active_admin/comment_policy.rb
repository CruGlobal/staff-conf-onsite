module ActiveAdmin
  class CommentPolicy < GeneralPolicy
    def destroy?
      user.admin? || record.author_id == user.id
    end
  end
end
