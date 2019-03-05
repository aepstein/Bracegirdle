class User < ApplicationRecord
  has_many :cemeteries,
    -> (user) {
      unscope(:where).where(
        county: REGIONS[user.region])}

  has_many :complaints,
    -> (user) {
      where('status < ?', Complaint::STATUSES[:pending_closure])
    },
    foreign_key: :investigator_id,
    inverse_of: :investigator

  has_many :notices,
    -> (user) {
      where('status < ?', Notice::STATUSES[:resolved])
    },
    foreign_key: :investigator_id,
    inverse_of: :investigator

  has_many :notifications

  has_many :restoration,
    -> (user) {
      where(status: [
        Restoration::STATUSES[:received]
      ])
    },
    foreign_key: :investigator_id,
    inverse_of: :investigator

  has_many :rules,
    -> (user) {
      if user.supervisor?
        unscope(:where).where(investigator: user, status: [2, 3]).or(where(status: 1))
      else
        where('status < ?', Rules::STATUSES[:approved]).order(:submission_date)
      end
    },
    foreign_key: :investigator_id,
    inverse_of: :investigator


  has_secure_password

  def first_name
    name.split(' ')[0]
  end

  def has_role?(test_role)
    role >= NAMED_ROLES[test_role]
  end

  def investigator?
    true
  end

  def region_name
    NAMED_REGIONS[region].capitalize
  end

  def signature
    filename = "#{name.to_s.downcase.split(' ').join}.tif"
    Pathname.new(Rails.root.join('app', 'pdfs', 'signatures', filename)).exist? ? filename : nil
  end

  def supervisor?
    has_role?(:supervisor)
  end
end
