class JobsController < ApplicationController
  respond_to :json

  def progress
    id = params[:job_id]

    respond_to do |format|
      format.json {
        render json: {
          id: id,
          percent: Sidekiq::Status.pct_complete(id)
        }
      }
    end
  end
end