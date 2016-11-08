class Ministry < ApplicationRecord
  CODES = %i(ACCOU AIA AIAFHQ CGL CGLFO CGN CGNFO CGP CGPFO CITY CITYCONV CM
             DSADMIN DS DSPRC DSRCS FAML FL00 FSG HQ USDSDC USDS USM).freeze

  CODE_TIERS = {
    USM: {
      AIA:  [:AIA, :AIAFHQ].freeze,
      CITY: [:CITY, :CITYCONV].freeze,
      FAML: [:FAML, :FL00].freeze
    }.freeze,
    HQ: {
      DS:   [:DSADMIN, :DSPRC, :DSRCS].freeze,
      FSG:  [:FSG, :ACCOU].freeze,
      USDS: [:USDS, :USDSDC].freeze
    }.freeze,
    CM: {
      CGL: [:CGL, :CGLFO].freeze,
      CGN: [:CGN, :CGNFO].freeze,
      CGP: [:CGP, :CGPFO].freeze,
    }.freeze
  }.freeze

  has_many :people

  validates :code, presence: true, inclusion: { in: CODES.map(&:to_s) }
end
