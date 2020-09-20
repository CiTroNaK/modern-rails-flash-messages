# frozen_string_literal: true

class DeleteWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(record_class, record_id)
    record_class.constantize.deleted.find(record_id).destroy
  end
end
