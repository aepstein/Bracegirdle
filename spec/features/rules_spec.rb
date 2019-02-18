require 'rails_helper'

feature 'Rules' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery,
      name: 'Anthony Cemetery',
      county: 4,
      order_id: 1)

    @other_region_cemetery = FactoryBot.create(:cemetery,
      name: 'Cayuga Cemetery',
      county: 6,
      order_id: 1)
  end

  scenario 'Unauthorized user tries to add rules' do
    expect { visit new_rule_path }.to raise_error(ApplicationController::Forbidden)
  end

  scenario 'Investigator adds new rules', js: true do
    login
    visit root_path

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
    visit rules_path

    expect(page).to have_content 'Anthony Cemetery'
  end

  scenario 'Investigator adds new rules without the sender name', js: true do
    login
    visit root_path

    click_on 'Inbox'
    click_on 'Rules and Regulations'
    click_on 'Upload new rules'
    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', from: 'Cemetery'
    fill_in 'Address', with: '223 Fake St.'
    fill_in 'City', with: 'Rotterdam'
    fill_in 'ZIP Code', with: '12345'
    attach_file 'rules_rules_documents', Rails.root.join('lib', 'document_templates', 'rules-approval.docx'), visible: false
    select2 'Chester Butkiewicz', from: 'Investigator'
    click_button 'Submit'

    expect(page).to have_content'There was a problem'
  end

  scenario "User can't do anything with somebody else's rules in progress" do
    @rules = FactoryBot.create(:another_investigator_rules)
    login
    @him = FactoryBot.create(:another_investigator)

    visit rule_path(@rules)

    expect(page).to_not have_content 'Approve Rules'
  end

  scenario "Can't approve rules when waiting for a revision" do
    @rules = FactoryBot.create(:revision_requested)
    login

    visit rule_path(@rules)

    expect(page).to_not have_content 'Approve Rules'
  end

  scenario 'Can approve rules once revision was received' do
    @rules = FactoryBot.create(:revision_requested_last_week)
    login

    visit rule_path(@rules)

    expect(page).to have_content 'Approve Rules'
  end

  scenario 'Can approve rules' do
    @rules = FactoryBot.create(:rules)
    @rules.update(investigator_id: 1)
    login

    visit rule_path(@rules)
    click_button 'Approve Rules'
    visit rule_path(@rules)

    expect(page).to have_content 'Approved'
  end

  scenario 'Supervisor has unassigned rules in queue' do
    @rules = FactoryBot.create(:rules)
    login_supervisor

    visit rules_path

    expect(page).to have_content 'Anthony Cemetery'
  end

  scenario "Supervisor does not have another user's rules in queue" do
    @rules = FactoryBot.create(:another_investigator_rules)
    login_supervisor
    @him = FactoryBot.create(:another_investigator)

    visit rules_path

    expect(page).to_not have_content 'Anthony Cemetery'
  end

  scenario 'Supervisor can assign rules', js: true do
    @rules = FactoryBot.create(:rules)
    login_supervisor
    @him = FactoryBot.create(:another_investigator)

    visit rule_path(@rules)
    select2 'Bob Wood', from: 'Investigator'
    click_on 'Assign Rules'
    logout
    login(@him)
    visit rules_path

    expect(page).to have_content 'Anthony Cemetery'
  end

  scenario 'Supervisor can approve unassigned rules', js: true do
    @rules = FactoryBot.create(:rules)
    login_supervisor

    visit rule_path(@rules)
    click_button 'Approve Rules'
    visit rule_path(@rules)

    expect(page).to have_content 'Approved'
  end
end