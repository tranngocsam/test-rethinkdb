class Api::V1::Tr::RequestsController < Api::V1::Tr::BaseController
  def top_ups_and_redeems
    if request_params.present?
      request = ApiRequest.create(request_params)
      if request.persisted?
        respond_results(request)
      else
        respond_error(:status => 422, :errors => request.errors)
      end
    else
      respond_error
    end
  end

  private

  def request_params
    params.require(:request).permit(:corp_code, :merchant_number, :card_number, :amount, :request_code)
  end
end
