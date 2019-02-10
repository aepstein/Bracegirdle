require 'rails_helper'

feature 'Notices' do
  before :each do
    @cemetery = FactoryBot.create(:cemetery,
      name: 'Anthony Cemetery',
      county: 4,
      order_id: 1)
  end

  scenario 'Unauthorized user tries to add notice' do
    expect { visit new_notice_path }.to raise_error(ApplicationController::Forbidden)
  end

  scenario 'Investigator issues notice', js: true do
    login
    visit root_path

    click_on 'Non-Compliance'
    click_on 'Issue new notice'
    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', from: 'Cemetery'
    fill_in 'Served On', with: 'Herman Munster'
    select 'President', from: 'Title'
    fill_in 'Address', with: '1313 Mockingbird Ln.'
    fill_in 'City', with: 'Rotterdam'
    fill_in 'ZIP Code', with: '12345'
    fill_in 'Law Sections', with: 'Testing.'
    fill_in 'Specific Information', with: 'Testing.'
    fill_in 'Violation Date', with: '12/31/2018'
    fill_in 'Response Required', with: '12/31/2019'
    click_on 'Submit'
    visit notices_path

    expect(page).to have_content'Anthony Cemetery'
  end

  scenario 'Investigator issues notice without specific information', js: true do
    login
    visit root_path

    click_on 'Non-Compliance'
    click_on 'Issue new notice'
    select2 'Broome', from: 'County'
    select2 '04-001 Anthony Cemetery', from: 'Cemetery'
    fill_in 'Served On', with: 'Herman Munster'
    select 'President', from: 'Title'
    fill_in 'Address', with: '1313 Mockingbird Ln.'
    fill_in 'City', with: 'Rotterdam'
    fill_in 'ZIP Code', with: '12345'
    fill_in 'Law Sections', with: 'Testing.'
    fill_in 'Violation Date', with: '12/31/2018'
    fill_in 'Response Required', with: '12/31/2019'
    click_on 'Submit'

    expect(page).to have_content'There was a problem'
  end

  scenario 'Notice can advance', js: true do
    login
    @notice = FactoryBot.create(:notice)

    visit notices_path
    click_on @notice.notice_number
    click_on 'Response Received'
    sleep(1)
    click_on 'Follow-Up Completed'
    sleep(1)
    click_button 'follow-up-completed'
    sleep(1)
    click_on 'Resolve Notice'
    visit notices_path

    expect(page).to have_content('There are no Notices')
  end

  scenario 'Can specify date of follow-up inspection', js: true do
    login
    @notice = FactoryBot.create(:notice)

    visit notices_path
    click_on @notice.notice_number
    click_on 'Response Received'
    sleep(1)
    click_button 'Follow-Up Completed'
    sleep(1)
    fill_in 'notice[follow_up_inspection_date]', with: '02/01/2019'
    all('h6').last.click
    click_on 'follow-up-completed'

    expect(page).to have_content 'Follow-up inspection completed on February 1, 2019'
  end
end