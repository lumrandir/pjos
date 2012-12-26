# coding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery

protected
  def get_socket
    @@pool ||= {}

    if s = @@pool[session[:session_id]]
      @socket = s
      return @socket
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
