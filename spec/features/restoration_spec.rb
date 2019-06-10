require 'rails_helper'

feature 'Restoration' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery,
      name: 'Anthony Cemetery',
      county: 4,
      order_id: 1)
    @trustee = FactoryBot.create(:trustee)
    @cemetery.trustees << @trustee
    @cemetery.save
    @contractor = FactoryBot.create(:contractor)
    @contractor.save
  end

  scenario 'Hazardous monument application can be uploaded', js: true do
    login
    visit root_path

    click_on 'Applications'
    click_on 'Hazardous Monuments'
    click_on 'Upload new application'
    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', from: 'Cemetery'
    select2 'Mark Clark', from: 'Submitted By'
    fill_in 'Submitted On', with: '02/28/2019'
    fill_in 'Amount', with: '12345.67'
    attach_file 'restoration_raw_application_file', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    click_on 'Upload Application'
    wait_for_ajax
    click_on 'Applications'
    click_on 'Hazardous Monuments'

    expect(page).to have_content 'Anthony Cemetery'
  end

  scenario 'Hazardous monument application can be processed', js: true do
    login
    visit root_path

    click_on 'Applications'
    click_on 'Hazardous Monuments'
    click_on 'Upload new application'
    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', from: 'Cemetery'
    select2 'Mark Clark', from: 'Submitted By'
    fill_in 'Submitted On', with: '02/28/2019'
    fill_in 'Amount', with: '12345.67'
    attach_file 'restoration_raw_application_file', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    click_on 'Upload Application'
    wait_for_ajax
    attach_file 'restoration_application_form', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    fill_in 'Number of Monuments', with: 25
    fill_in 'Date of Visit to Cemetery', with: '2/8/2019'
    choose 'restoration_application_form_complete_true'
    click_on 'Next'
    click_on 'Add New Estimate'
    attach_file 'estimate_document', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    fill_in 'Amount', with: '12345.67'
    select2 'Rocky Stone Monuments', from: 'Contractor'
    select2 'Lifetime', from: 'Warranty'
    choose 'estimate_proper_format_true'
    click_on 'Upload Estimate'
    click_on 'Next'
    attach_file 'restoration_legal_notice', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    fill_in 'Cost', with: '123.45'
    fill_in 'Newspaper', with: 'Albany Sun'
    choose 'restoration_legal_notice_format_true'
    click_on 'Next'
    choose 'restoration_previous_exists_true'
    attach_file 'restoration_previous_report', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    select2 'Hazardous', from: 'Type of Project'
    fill_in 'Date Previous Work Approved', with: 'September 2017'
    click_on 'Next'
    click_on 'Submit for Consideration'
    wait_for_ajax
    click_on 'Dashboard', match: :first
    visit restoration_index_path(type: :hazardous)

    expect(page).to have_content 'Sent to supervisor'
  end

  scenario 'Supervisor can send application directly to cemetery board', js: true do
    login_supervisor
    visit root_path

    click_on 'Applications'
    click_on 'Hazardous Monuments'
    click_on 'Upload new application'
    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', from: 'Cemetery'
    select2 'Mark Clark', from: 'Submitted By'
    fill_in 'Submitted On', with: '02/28/2019'
    fill_in 'Amount', with: '12345.67'
    attach_file 'restoration_raw_application_file', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    click_on 'Upload Application'
    wait_for_ajax
    attach_file 'restoration_application_form', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    fill_in 'Number of Monuments', with: 25
    fill_in 'Date of Visit to Cemetery', with: '2/8/2019'
    choose 'restoration_application_form_complete_true'
    click_on 'Next'
    click_on 'Add New Estimate'
    attach_file 'estimate_document', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    fill_in 'Amount', with: '12345.67'
    select2 'Rocky Stone Monuments', from: 'Contractor'
    select2 'Lifetime', from: 'Warranty'
    choose 'estimate_proper_format_true'
    click_on 'Upload Estimate'
    click_on 'Next'
    attach_file 'restoration_legal_notice', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    fill_in 'Cost', with: '123.45'
    fill_in 'Newspaper', with: 'Albany Sun'
    choose 'restoration_legal_notice_format_true'
    click_on 'Next'
    choose 'restoration_previous_exists_true'
    attach_file 'restoration_previous_report', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    select2 'Hazardous', from: 'Type of Project'
    fill_in 'Date Previous Work Approved', with: 'September 2017'
    click_on 'Next'
    click_on 'Submit for Consideration'
    wait_for_ajax
    click_on 'Dashboard', match: :first
    visit restoration_index_path(type: :hazardous)

    expect(page).to have_content 'Sent to Cemetery Board'
  end
end