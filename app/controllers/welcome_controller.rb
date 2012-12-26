class WelcomeController < ApplicationController
  before_filter :get_socket
  respond_to :html, :json

  def index
    response = {}

    respond_with do |format|
      format.json { render :json => response }
      format.html { render }
    end
  end
end
