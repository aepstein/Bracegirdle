require 'rails_helper'

feature 'Rules' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery)
    @other_region_cemetery = FactoryBot.create(:cemetery,
      name: 'Cayuga Cemetery',
      county: 6,
      order_id: 1)
  end

  scenario 'Investigator adds new rules', js: true do
    login
    visit new_rules_path

    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', from: 'Cemetery'
    fill_in 'Sender', with: 'Mark Smith'
    fill_in 'Address', with: '223 Fake St.'
    fill_in 'City', with: 'Rotterdam'
    fill_in 'ZIP Code', with: '12345'
    attach_file 'rules_rules_documents', Rails.root.join('spec', 'support', 'test.pdf'), visible: false
    select2 'Chester Butkiewicz', from: 'Investigator'
    click_button 'Submit'
    visit rules_index_path

    expect(page).to have_content 'Anthony Cemetery'
  end

  scenario 'Investigator adds new rules without selecting the cemetery', js: true do
    login
    visit new_rules_path

    select2 'Broome', from: 'County'
    fill_in 'Sender', with: 'Mark Smith'
    fill_in 'Address', with: '223 Fake St.'
    fill_in 'City', with: 'Rotterdam'
    fill_in 'ZIP Code', with: '12345'
    attach_file 'rules_rules_documents', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    select2 'Chester Butkiewicz', from: 'Investigator'
    click_button 'Submit'

    expect(page).to have_content 'There was a problem'
  end

  scenario "User can't do anything with somebody else's rules in progress" do
    @rules = FactoryBot.create(:another_investigator_rules)
    @rules.rules_documents.attach fixture_file_upload(Rails.root.join('lib', 'document_templates', 'rules-approval.docx'))
    login
    @him = FactoryBot.create(:another_investigator)

    expect{
      visit review_rules_path(@rules)
    }.to raise_error(Pundit::NotAuthorizedError)
  end

  scenario "Can't approve rules when waiting for a revision" do
    @rules = FactoryBot.create(:revision_requested)
    @rules.rules_documents.attach fixture_file_upload(Rails.root.join('lib', 'document_templates', 'rules-approval.docx'))
    login

    visit review_rules_path(@rules)

    expect(page).to_not have_content 'Approve Rules'
  end

  scenario 'Can request revision' do
    @rules = FactoryBot.create(:rules, investigator_id: 1)
    @rules.rules_documents.attach fixture_file_upload(Rails.root.join('lib', 'document_templates', 'rules-approval.docx'))
    login

    visit review_rules_path(@rules) # Visit is ok because we aren't waiting on anything
    click_button 'Request Revision'
    visit rules_index_path

    expect(page).to have_content 'Waiting for revisions'
  end

  scenario 'Can approve rules once revision was received' do
    @rules = FactoryBot.create(:revision_requested_last_week)
    @rules.rules_documents.attach fixture_file_upload(Rails.root.join('lib', 'document_templates', 'rules-approval.docx'))
    login

    visit review_rules_path(@rules)

    expect(page).to have_content 'Approve Rules'
  end

  scenario 'Can approve rules' do
    @rules = FactoryBot.create(:rules)
    @rules.update(investigator_id: 1)
    @rules.rules_documents.attach fixture_file_upload(Rails.root.join('lib', 'document_templates', 'rules-approval.docx'))
    login

    visit review_rules_path(@rules)
    click_button 'Approve Rules'

    expect(page).to have_content 'Approved'
  end

  scenario 'Supervisor has unassigned rules in queue' do
    @rules = FactoryBot.create(:rules)
    @rules.rules_documents.attach fixture_file_upload(Rails.root.join('lib', 'document_templates', 'rules-approval.docx'))
    login_supervisor

    visit rules_index_path

    expect(page).to have_content 'Anthony Cemetery'
  end

  scenario "Supervisor does not have another user's rules in queue" do
    @rules = FactoryBot.create(:another_investigator_rules)
    @rules.rules_documents.attach fixture_file_upload(Rails.root.join('lib', 'document_templates', 'rules-approval.docx'))
    login_supervisor
    @him = FactoryBot.create(:another_investigator)

    visit rules_index_path

    expect(page).to_not have_content 'Anthony Cemetery'
  end

  scenario 'Supervisor can assign rules', js: true do
    @rules = FactoryBot.create(:rules)
    @rules.rules_documents.attach fixture_file_upload(Rails.root.join('lib', 'document_templates', 'rules-approval.docx'))
    login_supervisor
    @him = FactoryBot.create(:another_investigator)

    visit review_rules_path(@rules)
    select2 'Bob Wood', from: 'Investigator'
    click_on 'Assign Rules'
    logout
    login(@him)
    visit rules_index_path

    expect(page).to have_content 'Anthony Cemetery'
  end

  scenario 'Supervisor can approve unassigned rules', js: true do
    @rules = FactoryBot.create(:rules)
    @rules.rules_documents.attach fixture_file_upload(Rails.root.join('lib', 'document_templates', 'rules-approval.docx'))
    login_supervisor

    visit review_rules_path(@rules)
    click_button 'Approve Rules'

    expect(page).to have_content 'APPROVED'
  end


  scenario 'User can upload a revision to rules', js: true do
    @rules = FactoryBot.create(:revision_requested)
    @rules.rules_documents.attach fixture_file_upload(Rails.root.join('lib', 'document_templates', 'rules-approval.docx'))
    login

    visit review_rules_path(@rules)
    attach_file 'rules_rules_documents', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    first(:button, 'Submit').click

    expect(page).to have_content 'REVISION 2'
  end

  scenario 'User cannot upload an invalid revision to rules', js: true do
    @rules = FactoryBot.create(:revision_requested)
    @rules.rules_documents.attach fixture_file_upload(Rails.root.join('lib', 'document_templates', 'rules-approval.docx'))
    login

    visit review_rules_path(@rules)
    attach_file 'rules_rules_documents', Rails.root.join('spec', 'support', 'test.txt'), visible: false
    first(:button, 'Submit').click

    expect(page).not_to have_content('REVISION 2', wait: 2)
  end

  scenario 'Investigator can add note to rules', js: true do
    @rules = FactoryBot.create(:rules)
    @rules.update(investigator_id: 1)
    @rules.rules_documents.attach fixture_file_upload(Rails.root.join('lib', 'document_templates', 'rules-approval.docx'))
    login

    visit review_rules_path(@rules)
    fill_in 'note[body]', with: 'Adding a note to these rules'
    all(:button, 'Submit').last.click

    expect(page).to have_content 'Adding a note to these rules'
  end

  scenario 'Investigator can upload old rules', js: true do
    @location = Location.new(latitude: 41.3144, longitude: -73.8964)
    @cemetery.locations << @location
    login
    visit upload_old_rules_path # Visit is ok because we are not waiting on anything

    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', from: 'Cemetery'
    attach_file 'rules_rules_documents', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    select2 'Chester Butkiewicz', from: 'Approved By'
    fill_in 'rules[approval_date]', with: '1/1/2019'
    click_on 'Submit'
    visit cemetery_path(@cemetery)

    expect(page).to have_content 'Approved January 1, 2019'
  end

  scenario 'Investigator cannot upload old rules without selecting the cemetery', js: true do
    @location = Location.new(latitude: 41.3144, longitude: -73.8964)
    @cemetery.locations << @location
    login
    visit upload_old_rules_path # Visit is ok because we are not waiting on anything

    select2 'Broome', from: 'County'
    attach_file 'rules_rules_documents', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    select2 'Chester Butkiewicz', from: 'Approved By'
    fill_in 'rules[approval_date]', with: '1/1/2019'
    click_on 'Submit'

    expect(page).to have_content 'There was a problem'
  end

  scenario 'Investigator can view approved rules' do
    @rules = FactoryBot.create(:approved_rules)
    @other_rules = FactoryBot.create(:approved_rules, approval_date: Date.current - 8.years)
    login

    visit rules_path(@rules)

    expect(page).to have_content "approved #{Date.current}"
  end

  scenario 'Investigator can view approved rules through cemetery' do
    @rules = FactoryBot.create(:approved_rules)
    @other_rules = FactoryBot.create(:approved_rules, approval_date: Date.current - 8.years)
    login

    visit rules_cemetery_path(@cemetery)

    expect(page).to have_content "approved #{Date.current}"
  end

  scenario 'Investigator can download letter for approved rules that were emailed' do
    @rules = FactoryBot.create(:approved_rules)
    login

    visit download_approval_rules_path(@rules, filename: 'test')

    expect(page.status_code).to be 200
  end

  scenario 'Investigator can download letter for approved rules that were mailed' do
    @rules = FactoryBot.create(:approved_rules_mailed)
    login

    visit download_approval_rules_path(@rules, filename: 'test')

    expect(page.status_code).to be 200
  end
end
