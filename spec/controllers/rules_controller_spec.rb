require 'rails_helper'
require 'permissions_test'

describe RulesController, type: :controller do
  before do
    @users = Hash.new
    @users[:investigator] = FactoryBot.create(:user)
    @users[:cemeterian] = FactoryBot.create(:cemeterian)
    @users[:accountant] = FactoryBot.create(:accountant)
    @users[:support] = FactoryBot.create(:support)
    @users[:another_investigator] = FactoryBot.create(:another_investigator)
    @users[:mean_supervisor] = FactoryBot.create(:mean_supervisor)
    @cemetery = FactoryBot.create(:cemetery)
    @object = FactoryBot.create(:rules, investigator_id: 1, status: :pending_review)
    @unassigned = FactoryBot.create(:rules)
  end

  context 'All staff' do
    allowed = %i(investigator accountant support)
    disallowed = %i(cemeterian)
    actions = {
      new: :get,
      upload_old_rules: :get
    }

    actions.each do |action, method|
      permissions_test(allowed, disallowed, action, method).call
    end

    dummy_rules = FactoryBot.build(:rules).attributes
    permissions_test(allowed, disallowed, :create, :post, true, rules: dummy_rules).call
    permissions_test(allowed, disallowed, :create_old_rules, :post, true, rules: dummy_rules).call
    permissions_test(allowed, disallowed, :download_approval, :get, true, filename: 'Test.pdf').call
    permissions_test(allowed, disallowed, :upload_revision, :post, true, rules: { submission_date: '03/12/2020' }).call
    permissions_test(allowed, disallowed, :show, :get, true).call
  end

  context 'Just the investigator who owns object or supervisor' do
    allowed = %i(investigator mean_supervisor)
    disallowed = %i(cemeterian another_investigator accountant support)

    permissions_test(allowed, disallowed, :review, :get, true).call
  end

  context 'Just the investigator who owns object' do
    allowed = %i(investigator)
    disallowed = %i(cemeterian another_investigator mean_supervisor accountant support)

    permissions_test(allowed, disallowed, :approve, :patch, true, status: :found).call
  end

  context 'Just supervisor' do
    allowed = %i(mean_supervisor)
    disallowed = %i(cemeterian investigator another_investigator accountant support)

    permissions_test(allowed, disallowed, :approve, :patch, true, status: :found, object_id: 2).call
    permissions_test(allowed, disallowed, :assign, :patch, true, rules: { investigator: 2 }, status: :found).call
  end
end
