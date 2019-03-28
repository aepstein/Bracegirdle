require 'rails_helper'

feature 'Activities' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery,
      name: 'Anthony Cemetery',
      county: 4,
      order_id: 1
    )
  end

  scenario 'Adding a complaint logs activity', js: true do
    login
    click_on 'Complaints'
    click_on 'Add new complaint'
    fill_in 'complaint[complainant_name]', with: 'Herman Munster'
    fill_in 'complaint[complainant_address]', with: '1313 Mockingbird Ln., Rotterdam, NY 13202'
    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', css: '#complaint-cemetery-select-area'
    select2 'Burial issues', from: 'Complaint Type'
    fill_in 'complaint[summary]', with: 'Testing.'
    fill_in 'complaint[form_of_relief]', with: 'Testing'
    fill_in 'complaint[date_of_event]', with: '12/31/2018'
    all('span', text: 'Yes').last.click
    select2 'Chester Butkiewicz', from: 'Investigator'
    click_on 'Submit'

    visit root_path

    expect(page).to have_content 'Chester Butkiewicz received a complaint against Anthony Cemetery'
  end

  scenario 'Adding note to complaint logs activity', js: true do
    login
    @complaint = FactoryBot.create(:brand_new_complaint)

    visit complaint_path(@complaint)
    click_on 'Investigation Details'
    fill_in 'note[body]', with: 'Adding a note to this complaint'
    click_on 'Submit'
    visit complaint_path(@complaint) # Necessary to fix a timing issue
    visit root_path

    expect(page).to have_content 'Chester Butkiewicz commented on complaint #2019-0001 against Anthony Cemetery'
  end

  scenario 'Adding new rules logs activity', js: true do
    login
    click_on 'Inbox'
    click_on 'Rules and Regulations'
    click_on 'Upload new rules'
    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', from: 'Cemetery'
    fill_in 'Sender', with: 'Mark Smith'
    fill_in 'Address', with: '223 Fake St.'
    fill_in 'City', with: 'Rotterdam'
    fill_in 'ZIP Code', with: '12345'
    attach_file 'rules_rules_documents', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    select2 'Chester Butkiewicz', from: 'Investigator'
    click_button 'Submit'

    visit root_path

    expect(page).to have_content 'Chester Butkiewicz uploaded new rules for Anthony Cemetery'
  end

  scenario 'Approving rules logs activity', js: true do
    @rules = FactoryBot.create(:rules)
    @rules.update(investigator_id: 1)
    login
    visit rules_path(@rules)
    click_button 'Approve Rules'

    visit root_path

    expect(page).to have_content 'Chester Butkiewicz approved rules for Anthony Cemetery'
  end

  scenario 'Assigning rules logs activity', js: true do
    @rules = FactoryBot.create(:rules)
    login_supervisor
    @him = FactoryBot.create(:another_investigator)
    visit rules_path(@rules)
    select2 'Bob Wood', from: 'Investigator'
    click_on 'Assign Rules'

    visit root_path

    expect(page).to have_content 'Chester Butkiewicz assigned rules for Anthony Cemetery to Bob Wood'
  end

  scenario 'Uploading a revision to rules logs activity', js: true do
    @rules = FactoryBot.create(:revision_requested)
    login
    visit rules_path(@rules)
    attach_file 'rules_rules_documents', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    first(:button, 'Submit').click

    visit root_path

    expect(page).to have_content 'Chester Butkiewicz received a revision to rules for Anthony Cemetery'
  end

  scenario 'Issuing a notice logs activity', js: true do
    login
    visit root_path
    click_on 'Non-Compliance'
    click_on 'Issue new notice'
    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', from: 'Cemetery'
    fill_in 'Served On', with: 'Herman Munster'
    select2 'Treasurer', from: 'Title'
    fill_in 'Address', with: '1313 Mockingbird Ln.'
    fill_in 'City', with: 'Rotterdam'
    fill_in 'ZIP Code', with: '12345'
    fill_in 'Law Sections', with: 'Testing.'
    fill_in 'Specific Information', with: 'Testing.'
    fill_in 'Violation Date', with: '12/31/2018'
    fill_in 'Response Required', with: '12/31/2019'
    click_on 'Submit'

    visit root_path

    expect(page).to have_content 'Chester Butkiewicz issued a Notice of Non-Compliance to Anthony Cemetery'
  end

  scenario 'Receiving a response to a notice logs activity', js: true do
    login
    @notice = FactoryBot.create(:notice)
    visit notices_path
    click_on @notice.notice_number
    click_on 'Response Received'

    visit root_path

    expect(page).to have_content 'Chester Butkiewicz received a response to a Notice of Non-Compliance from Anthony Cemetery'
  end

  scenario 'Uploading a hazardous monument application logs activity', js: true do
    @trustee = FactoryBot.create(:trustee)
    @cemetery.trustees << @trustee
    @cemetery.save
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
    sleep(0.5)

    visit root_path

    expect(page).to have_content 'Chester Butkiewicz received a restoration application for Anthony Cemetery'
  end
end