require 'rails_helper'

def create_cemetery_inspection
  @cemetery = FactoryBot.create(:cemetery)
  CemeteryInspection.new(status: :begun)
end

describe CemeteryInspection, type: :model do
  subject { create_cemetery_inspection }

  context 'Instance Methods' do
    describe CemeteryInspection, '#current_inspection_step' do
      it 'returns the correct number' do
        subject.renovations = 'None noted.'

        expect(subject.current_inspection_step).to eq 2
      end
    end

    describe CemeteryInspection, '#named_status' do
      it 'returns the correct named status' do
        expect(subject.named_status).to eq 'In progress'
      end
    end

    describe CemeteryInspection, '#violations?' do
      it 'returns true if there was at least one violation' do
        subject.update(sign: false)

        expect(subject.violations?).to be true
      end

      it 'returns false if there were no violations' do
        subject.update(
          sign: true,
          receiving_vault_clean: true,
          receiving_vault_obscured: true,
          receiving_vault_secured: true,
          receiving_vault_exclusive: true,
          annual_meetings: true,
          election: true,
          burial_permits: true,
          body_delivery_receipt: true,
          deeds_signed: true,
          rules_provided: true,
          rules_approved: true
        )

        expect(subject.violations?).to be false
      end

      it 'returns false if the inspection had no violations even if the receiving vault was not inspected' do
        subject.update(
          sign: true,
          annual_meetings: true,
          election: true,
          burial_permits: true,
          body_delivery_receipt: true,
          deeds_signed: true,
          rules_provided: true,
          rules_approved: true
        )

        expect(subject.violations?).to be false
      end
    end
  end
end
