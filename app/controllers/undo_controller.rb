# frozen_string_literal: true

require 'sidekiq/api'

class UndoController < ApplicationController
  def destroy
    job = Sidekiq::ScheduledSet.new.find_job(params[:id])
    done = recover_record(job)

    if done
      response = prepare_response(job)
      respond_to do |format|
        format.json { render json: response, status: :ok }
      end
    else
      head :unprocessable_entity
    end
  end

  private

  def recover_record(job)
    return false unless job

    job.delete
    record = job.item['args'][0].constantize.find(job.item['args'][1])
    record.recover

    true
  end

  def prepare_response(job)
    inline = params[:inline].presence ? true : false
    {
      message: inline ? 'Done!' : 'Done! Reloading the page...',
      inline: inline,
      record_id: (job.item['args'][1] if job),
      record_class: (job.item['args'][0] if job)
    }
  end
end
