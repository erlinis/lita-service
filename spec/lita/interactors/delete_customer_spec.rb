# frozen_string_literal: false
require 'spec_helper'

describe Lita::Interactors::DeleteCustomer do
  let(:data) { ['the-service delete @erlinis', name, 'delete', '@erlinis', nil] }
  let(:interactor) { described_class.new(handler, data) }
  let(:handler) { double('handler') }
  let(:fake_repository) { double('redis-repository') }

  before do
    allow(interactor).to receive(:repository).and_return(fake_repository)
  end

  describe '#perform' do
    let(:name) { 'the-service' }

    describe 'when the service does not exist' do
      let(:error_message) do
        I18n.t('lita.handlers.service.errors.not_found', service_name: name)
      end

      before do
        allow(fake_repository).to receive(:exists?).with(name).and_return(false)
      end

      it 'shows an error message' do
        interactor.perform
        expect(interactor.success?).to eq false
        expect(interactor.error).to eq error_message
      end
    end

    describe 'when service exists' do
      let(:service) do
        { name: name,
          value: 2000,
          state: 'active',
          customers: { erlinis: { quantity: 1, value: 2000 } } }
      end

      let(:service_without_customer) do
        { name: name,
          value: 2000,
          state: 'active',
          customers: {} }
      end

      describe 'customer is in service' do
        let(:success_message) do
          I18n.t('lita.handlers.service.delete_customer.success',
                 service_name: name, customer_name: 'erlinis')
        end

        before do
          allow(fake_repository).to receive(:exists?).with(name).and_return(true)
          allow(fake_repository).to receive(:find).with(name).and_return(service)
        end

        it 'removes customer from service' do
          expect(fake_repository).to receive(:update).with(service_without_customer)
          interactor.perform
          expect(interactor.success?).to eq true
          expect(interactor.message).to eq success_message
        end
      end

      describe 'customer not in service' do
        let(:error_message) do
          I18n.t('lita.handlers.service.customer.not_found',
                 service_name: name, customer_name: 'erlinis')
        end

        before do
          allow(fake_repository).to receive(:exists?).with(name).and_return(true)
          allow(fake_repository).to receive(:find).with(name)
            .and_return(service_without_customer)
        end

        it 'shows a customer not found error' do
          interactor.perform
          expect(interactor.success?).to eq false
          expect(interactor.error).to eq error_message
        end
      end
    end
  end
end
