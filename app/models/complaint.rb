# frozen_string_literal: true

class Complaint < ApplicationRecord
  include Notable

  before_create :set_complaint_number

  belongs_to :cemetery, optional: true
  belongs_to :receiver, class_name: 'User', foreign_key: :receiver_id
  belongs_to :investigator, class_name: 'User', foreign_key: :investigator_id, optional: true

  scope :unassigned, -> { where(investigator: nil) }

  validates :complainant_name, presence: true
  validates :complaint_type, presence: true
  validates :summary, presence: true
  validates :form_of_relief, presence: true
  validates :date_of_event, presence: true
  validate :cemetery_is_completed

  def self.grouped_complaint_types
    GROUPED_COMPLAINT_TYPES
  end

  def self.raw_complaint_types
    RAW_COMPLAINT_TYPES
  end

  def cemetery_contact
    if person_contacted
      string = person_contacted
      (string << ' (by ' << manner_of_contact.split(', ').map { |manner| MANNERS_OF_CONTACT[manner.to_i].downcase }.join(', ') << ')') if manner_of_contact
      string
    else
      'No cemetery contact information provided'
    end
  end

  def complaint_type
    self[:complaint_type].split(', ') if self[:complaint_type].respond_to? :split
  end

  def formatted_cemetery
    if cemetery_alternate_name
      cemetery_alternate_name
    else
      cemetery.name
    end
  end

  def formatted_ownership
    # Return empty string if not provided
    return '' if name_on_deed.blank?

    return_string = "Owned by #{name_on_deed}"
    return_string += " (#{relationship})" if relationship
    return_string
  end

  def last_action
    COMPLAINT_STATUSES[status]
  end

  def ownership_type_string
    OWNERSHIP_TYPES[ownership_type]
  end

  def to_s
    complaint_number
  end

  def unassigned?
    investigator.nil?
  end

  private

  def cemetery_is_completed
    if cemetery_regulated?
      errors.add(:cemetery, :blank) unless cemetery
    else
      errors.add(:cemetery_alternate_name, :blank) unless cemetery_alternate_name
    end
  end

  def set_complaint_number
    complaint_number = "#{date_acknowledged.year}-#{'%04d' % id}"
  end
end