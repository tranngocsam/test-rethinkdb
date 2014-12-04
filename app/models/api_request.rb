class ApiRequest
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :corp_code, :type => String
  field :merchant_number, :type => String
  field :card_number, :type => String
  field :amount, :type => Float
  field :request_code, :type => String
  field :upstream_response, :type => Hash

  def self.csv_headers
    fields.keys.sort
  end

  def self.xlsx_headers
    fields.keys.sort
  end

  def to_csv
    self.full_attributes.sort{|a, b| a.first <=> b.first}.map(&:last)
  end

  def to_xlsx
    self.full_attributes.sort{|a, b| a.first <=> b.first}.map(&:last)
  end

  def full_attributes
    attrs = self.class.fields.keys.inject({}){|r, k|
      r[k.to_s] = nil
      r
    }
    attrs.merge(self.attributes).merge("id" => self.id)
  end
end
