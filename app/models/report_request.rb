class ReportRequest
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :sp, :type => String
  field :sp_params, :type => Hash
  field :status, :type => Boolean

  def submit_request
    
  end
end
