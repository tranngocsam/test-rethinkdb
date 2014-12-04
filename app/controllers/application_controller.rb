class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_access_control_headers

  private

  def respond_results(results, meta = {})
    respond_to do |format|
      format.json {
        if results.kind_of?(Hash) && results.has_key?(:results)
          json = results.merge({})
        else
          json = {:results => results}
        end

        if meta[:pagination].present?
          json[:pagination] = meta.delete(:pagination)
        elsif results.respond_to?(:total_entries)
          json[:pagination] = pagination_json(results)
        end

        meta[:status] ||= 200
        json[:meta] = meta

        render :json => json, :status => meta[:status]
      }
      format.csv {
        @results = results
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=#{meta[:filename] || action_name}.csv"
        render :template => "pages/response"
      }
      format.xlsx {
        @results = results
        response.headers['Content-Type'] = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        response.headers['Content-Disposition'] = "attachment; filename=#{meta[:filename] || action_name}.xlsx"
        render :template => "pages/response"
      }
    end
  end

  def respond_error(options = {})
    options[:status] ||= 500
    options[:code] ||= case options[:status]
    when 404
      :not_found
    when 422
      :unprocess_entity
    when 500
      :internal_error
    else
      :unknown_error
    end

    respond_to do |format|
      format.json {
        render :json => options, :status => options[:status]
      }
      format.html { render :status => options[:status]}
    end
  end

  def pagination_json(results)
    {
      :count => results.total_entries,
      :total_pages => results.total_pages,
      :current_page => results.current_page.to_i,
      :per_page => results.per_page
    }
  end

  def as_json_results(results, options = {})
    options[:include] ||= {}
    if options.present?
      results.as_json(options)
    else
      results.as_json
    end
  end

  def set_access_control_headers
    headers['Access-Control-Allow-Headers'] = '*, X-CSRF-Token, X-Requested-With, Content-Type, Content-Range, Content-Disposition, Content-Description'
    headers['Access-Control-Allow-Credentials'] = "true"
    headers['Access-Control-Allow-Origin'] = request.env['HTTP_ORIGIN'] if request.env['HTTP_ORIGIN'].present? && APP_CONFIG.app.api.allowed_origins.include?(request.env['HTTP_ORIGIN'])
    headers['Access-Control-Allow-Methods'] = "POST, PUT, DELETE, PATCH, GET, OPTIONS"
  end 
end
