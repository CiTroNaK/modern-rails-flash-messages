# frozen_string_literal: true

module SoftDelete
  extend ActiveSupport::Concern

  included do
    scope :active, -> { where(deleted_at: nil) }
    scope :deleted, -> { where.not(deleted_at: nil) }
  end

  def schedule_destroy
    timeout = defined?(UNDO_TIMEOUT) ? UNDO_TIMEOUT : 8
    update(deleted_at: Time.zone.now.utc)
    DeleteWorker.perform_in(timeout.seconds + 5.seconds, self.class.name, id)
  end

  def recover
    update(deleted_at: nil)
  end
end
