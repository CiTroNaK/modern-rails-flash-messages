# frozen_string_literal: true

module DestroyWithUndoResponse
  extend ActiveSupport::Concern

  private

  def destroy_with_undo_response(record:, job_id:, redirect:)
    respond_to do |format|
      format.html do
        flash[:success] = undo_flash_message(klass: record.class, job_id: job_id)
        redirect_to redirect
      end
      format.turbo_stream do
        if params[:redirect]
          flash[:success] = undo_flash_message(klass: record.class, job_id: job_id)
          redirect_to redirect
        else
          flash.now[:success] = undo_flash_message(klass: record.class, job_id: job_id, inline: true)
          render 'undo/destroy', locals: { record: record }
        end
      end
    end
  end

  def undo_flash_message(klass:, job_id:, inline: nil)
    timeout = defined?(klass::UNDO_TIMEOUT) ? klass::UNDO_TIMEOUT : 10

    {
      title: "#{klass.model_name.human} was removed",
      body: 'You can recover it using the undo action below.',
      timeout: timeout, countdown: true,
      action: {
        url: undo_path(job_id, inline: inline),
        method: 'delete',
        name: 'Undo'
      }
    }
  end
end
