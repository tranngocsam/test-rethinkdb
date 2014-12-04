class Api::V1::Report::RequestsController < Api::V1::Report::BaseController
  def report
    if report_params.present?
      request = ReportRequest.create(report_params)

      if request.persisted?
        respond_results(request)
      else
        respond_error(:status => 422, :errors => request.errors)
      end
    else
      respond_error
    end
  end

  def show
    request = ReportRequest.find(params[:id])
    ReportWorker.perform_async(request.id)
    respond_results(request)
  rescue Exception => e
    if e.message.include?("#{params[:id]} not found")
      respond_error(:status => 404)
    else
      respond_error
    end
  end

  private

  def report_params
    params.require(:report).permit(:sp).tap do |wl|
      wl[:sp_params] = params[:report][:sp_params] if params[:report][:sp_params]
    end
  end
end
