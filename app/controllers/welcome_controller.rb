# coding: utf-8

require "pp"

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

private
  def get_socket
    @@pool ||= {}

    if s = @@pool[session[:session_id]]
      s.close
    end

    begin 
      @socket = TCPSocket.new "localhost", 1337
    rescue Errno::ECONNREFUSED
      flash[:error] = "Сервер решателя недоступен!"

      respond_with do |format|
        format.json { render :json => { 
          :message => { 
            :error => "Сервер решателя недоступен!" } 
          } 
        }
        format.html { render }
      end
    end

    @@pool[session[:session_id]] = @socket
  end
end
