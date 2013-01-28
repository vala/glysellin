module Glysellin
  class Payment < ActiveRecord::Base
    self.table_name = 'glysellin_payments'

    belongs_to :order, :inverse_of => :payments
    belongs_to :type, :class_name => 'PaymentMethod', :foreign_key => 'type_id', :inverse_of => :payments

    attr_accessible :status, :type_id, :type, :order, :order_id,
      :last_payment_action_on, :transaction_id

    # Public: Status const to be used if payment pending
    PAYMENT_STATUS_PENDING = 'pending'
    # Public: Status const to be used if payment paid
    PAYMENT_STATUS_PAID = 'paid'
    # Public: Status const to be used if payment canceled
    PAYMENT_STATUS_CANCELED = 'canceled'

    def new_status s
      self.status = s
      self.last_payment_action_on = Time.now
      self.save
    end

    def new_transaction_id!
      last_transaction_with_id = self.class.where('transaction_id > 0').order('updated_at DESC').first
      next_id = last_transaction_with_id ? last_transaction_with_id.transaction_id + 1 : 1
      self.transaction_id = next_id
      self.save
    end

    def get_new_transaction_id
      self.new_transaction_id!
      self.transaction_id
    end

    def status_enum
      [PAYMENT_STATUS_PAID, PAYMENT_STATUS_PENDING, PAYMENT_STATUS_CANCELED].map do |s|
        [I18n.t("glysellin.labels.payments.statuses.#{ s }"), s]
      end
    end

    def by_check?
      type.slug == 'check'
    end
  end
end
