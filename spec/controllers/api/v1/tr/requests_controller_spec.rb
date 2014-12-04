require 'rails_helper'

describe Api::V1::Tr::RequestsController do
  let(:request_params){
    {
      :corp_code => ("a".."z").to_a.sample(10).join, 
      :merchant_number => (0..9).to_a.sample(5).join, 
      :card_number => (0..9).to_a.sample(14).join,
      :amount => rand(100),
      :request_code => ("a".."z").to_a.sample(5).join
    }
  }
  describe "POST top_ups_and_redeems" do
    context "with valid parameters" do
      it "should create api request on the local database with all parameters" do
        number = ApiRequest.count
        post :top_ups_and_redeems, :request => request_params, :format => :json
        expect(response).to be_success
        expect(ApiRequest.count).to eql(number + 1)
      end

      it "should response to csv request" do
        post :top_ups_and_redeems, :request => request_params, :format => :csv
        expect(response).to be_success
        expect(response.header["Content-Type"]).to eql("text/csv")
        expect(response).to render_template("pages/response")
      end

      it "should response to xslx request" do
        post :top_ups_and_redeems, :request => request_params, :format => :xlsx
        expect(response).to be_success
        expect(response.header["Content-Type"]).to eql("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
        expect(response).to render_template("pages/response")
      end
    end

    context "with invalid parameters" do
      it "should not create api request if required parameters are blank" do
        number = ApiRequest.count
        post :top_ups_and_redeems, :request => {:none => ""}, :format => :json

        expect(response).not_to be_success
        expect(ApiRequest.count).to eql(number)
      end
    end
  end
end
