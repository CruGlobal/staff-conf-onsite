class Ministry < ApplicationRecord
  has_paper_trail

  has_many :people
  has_many :children, class_name: 'Ministry', foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'Ministry'

  validates :code, uniqueness: true
  validate :no_self_parent

  default_scope { includes :parent }

  # Ministries are structured in organizational hieararchy (think of an "org.
  # chart"), which each Ministry can have a hierarchy of "sub-ministries"
  # beneath it.
  #
  # @param [ActiveRecord::Relation] relation The ministries to build the
  #   hieararchy from. {#all} will be used if left nil.
  # @return [Hash<Ministry, Hash>] Each key is a Ministry record and each
  #   associated value is a hash of that ministry's descendants. If the ministry
  #   has no descendants (a leaf), this hash will be empty.
  def self.hierarchy(relation = nil)
    relation ||= all

    hierarchy = {}
    subtrees = {}
    ministries = relation.to_a

    while ministries.any?
      m = ministries.shift

      if m.parent.nil? # top level
        subtrees[m] = hierarchy[m] = {}
      elsif (parent_tree = subtrees[m.parent])
        subtrees[m] = parent_tree[m] = {}
      else # parent hasn't been seen yet. try again later
        ministries.push(m)
      end
    end

    hierarchy
  end

  # @return [Array<Ministry] a top-down list of this ministry's ancestors. ie:
  #   it's parent, grandparent, grandparent's parent, etc.
  def ancestors
    ancestors = []

    ministry = parent
    while ministry.present?
      ancestors << ministry
      ministry = ministry.parent
    end

    ancestors.reverse
  end

  def to_s
    "#{code}: #{name}"
  end

  def audit_name
    "#{super}: #{self}"
  end

  private

  def no_self_parent
    if parent_id.present? && id == parent_id
      errors.add(:parent_id, 'can\'t be your own parent')
    end
  end
end
