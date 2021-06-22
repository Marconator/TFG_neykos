class EmailsController < ApplicationController
before_action :authenticate_user!
  # GET /emails
  # GET /emails.json
  def index
    #Notifications
    @allNotifications = Notification.where("notify_app = true AND triggered = true").order(start_time: :desc).limit(3)
    @triggeredNotifications = Notification.where("notify_app = true AND triggered = true").count

    #Emails
    @clients = Client.all
  end

  # DELETE /emails/1
  # DELETE /emails/1.json
  def destroy
    Email.find(params[:id]).destroy
    redirect_to action: "index"
  end

  # POST /emails
  # POST /emails.json
  def create
    if Email.where("email = ? AND client_id = ?", params[:email], params[:client_id]).exists?
      flash[:alert_error] = "Este correo ya existe."
    else
      flash[:alert_success] = "Correo añadido correctamente."
      Email.create(email: params[:email], client_id: params[:client_id])
    end
    redirect_to action: "index"
  end
end
