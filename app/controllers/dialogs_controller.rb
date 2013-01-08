# coding: utf-8

class DialogsController < ApplicationController
  before_filter :get_socket

  def answer
    @socket.write params[:answer]
    data = @socket.recv(1000).force_encoding("utf-8")

    render :json => { :data => data }
  end

  def reload
    @socket.close
    @@pool[session[:session_id]] = nil

    render :json => {}
  end

  def question
    render :json => { :data => @socket.recv(1000).force_encoding("utf-8") }
  end  
end
