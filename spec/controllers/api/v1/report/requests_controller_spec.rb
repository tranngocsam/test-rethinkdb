require 'rails_helper'

describe Api::V1::Report::RequestsController do
  let(:report_params){
    {
      :sp => ("a".."z").to_a.sample(10).join, 
      :sp_params => {:number => rand(10)}
    }
  }
  describe "POST report" do
    context "with valid parameters" do
      it "should create report request on the local database with all parameters" do
        number = ReportRequest.count
        post :report, :report => report_params, :format => :json
        expect(response).to be_success
        expect(ReportRequest.count).to eql(number + 1)
      end

      it "should response to csv request" do
        post :report, :report => report_params, :format => :csv
        expect(response).to be_success
        expect(response.header["Content-Type"]).to eql("text/csv")
        expect(response).to render_template("pages/response")
      end

      it "should response to xslx request" do
        post :report, :report => report_params, :format => :xlsx
        expect(response).to be_success
        expect(response.header["Content-Type"]).to eql("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
        expect(response).to render_template("pages/response")
      end
    end

    context "with invalid parameters" do
      it "should not create report request if required parameters are blank" do
        number = ReportRequest.count
        post :report, :report => {:none => ""}, :format => :json

        expect(response).not_to be_success
        expect(ReportRequest.count).to eql(number)
      end
    end
  end

  describe "GET show" do
    context "with valid parameters" do
      it "should return local report request on the local database with all parameters" do
        report_request = ReportRequest.create!(:sp => ("a".."z").to_a.sample(5).join, :sp_params => {:number => rand(10)})
        get :show, :id => report_request.id, :format => :json
        expect(response).to be_success
        json = JSON.parse(response.body)
        expect(json["results"]).to be_present
        expect(json["results"]["id"]).to eql(report_request.id)
      end

      it "should response to csv request" do
        report_request = ReportRequest.create!(:sp => ("a".."z").to_a.sample(5).join, :sp_params => {:number => rand(10)})
        get :show, :id => report_request.id, :format => :csv
        expect(response).to be_success
        expect(response.header["Content-Type"]).to eql("text/csv")
        expect(response).to render_template("pages/response")
      end

      it "should response to xslx request" do
        report_request = ReportRequest.create!(:sp => ("a".."z").to_a.sample(5).join, :sp_params => {:number => rand(10)})
        get :show, :id => report_request.id, :format => :xlsx
        expect(response).to be_success
        expect(response.header["Content-Type"]).to eql("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
        expect(response).to render_template("pages/response")
      end
    end

    context "with invalid parameters" do
      it "should not return local report request if required parameters are blank" do
        get :show, :id => "anyid", :format => :json

        expect(response).to be_not_found
      end
    end
  end
end
