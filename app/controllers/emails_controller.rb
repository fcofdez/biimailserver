class EmailsController < ApplicationController

  def create
    email = Email.new_from_hash(params)
    @id = $server.send(email)

    respond_to do |format|
      if @id.present?
        format.json { render json: @id, status: :created }
      else
        format.json { render json: "error", status: :unprocessable_entity }
      end
    end
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
      format.json { render json: { new_mails: @new_mails } }
    end
  end

  def new_mails
    @new_mails = $server.new_mails(params[:receiver]).map(&:to_s)
    respond_to do |format|
      format.json { render json: @new_mails }
    end
  end

end
