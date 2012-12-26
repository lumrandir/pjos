# coding: utf-8

class DialogsController < ApplicationController
  before_filter :get_socket

  def answer
    @socket.write params[:answer]
    data = @socket.gets.force_encoding("utf-8")

    render :json => { :data => data }
  end

  def reload
    @@pool[session[:session_id]].close
    @@pool[session[:session_id]] = nil

    render :json => {}
  end

  def question
    render :json => { :data => @socket.gets.force_encoding("utf-8") }
  end  
end
