class EmailsController < ApplicationController

  def create
    Email.new_from_hash(params)
    $server.send(email)
  end

  def show
    @email = $server.fetch(params[:receiver], BSON::ObjectId(params[:id])).to_hash
    respond_to do |format|
      format.json { render json: @email.to_hash }
    end
  end

  def has_new_mail
    @new_mails = $server.has_new_mail?(params[:receiver])
    respond_to do |format|
      format.json { render json: @new_mails }
    end
  end

  def new_mails
    $server.new_mails(params[:receiver])
  end

end
