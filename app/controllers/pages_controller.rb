class PagesController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:options]

  def options
    head :ok
  end
end
