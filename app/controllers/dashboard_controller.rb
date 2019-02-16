class DashboardController < ApplicationController
  def index
    redirect_to login_path and return unless current_user

    if current_user.supervisor?
      @complaints = Complaint.active_for(current_user).or(Complaint.pending_closure).or(Complaint.unassigned).count
    else
      @complaints = Complaint.active_for(current_user).count
    end
    @notices = Notice.active.where(investigator: current_user).count
    @title = 'Dashboard'
  end

  def search
    if params[:search] =~ /^[\d-]{1,6}$/
      /(?<county>\d{2})-?(?<id>\d+)/ =~ params[:search]
      @cemeteries = Cemetery.where(county: county.to_i, order_id: id.to_i)
    else
      @cemeteries = Cemetery.where('name LIKE :name COLLATE NOCASE', name: "%#{params[:search]}%")
    end

    respond_to do |m|
      m.js { render partial: 'dashboard/search' }
    end
  end
end
