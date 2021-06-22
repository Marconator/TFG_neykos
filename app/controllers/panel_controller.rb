class PanelController < ApplicationController
before_action :authenticate_user!

  # GET /panel
  # GET /panel.json
  def index
    #Notifications
    @allNotifications = Notification.where("notify_app = true AND triggered = true").order(start_time: :desc).limit(3)
    @triggeredNotifications = Notification.where("notify_app = true AND triggered = true").count

    #Paneles
    @clients = Client.all
  end

  # PUT /panel/1
  def update
    Client.find(params[:id]).update(name: params[:name])
    redirect_to action: "index"
  end

end
