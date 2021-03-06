class TrusteesController < ApplicationController
  def api_list
    render html: helpers.trustees_for_select(Cemetery.includes(:trustees).find(params[:id]), params.key?(:name_only) ? :name : :id)
  end

  def api_show
    @trustee = Trustee.find(params[:id])
    respond_to do |format|
      format.json { render json: @trustee.to_json }
    end
  end

  def create
    @cemetery = Cemetery.find_by_cemetery_id(params[:cemetery_cemetery_id])
    @trustee = @cemetery.trustees.create(trustee_params)
  end

  def update
    @trustee = Trustee.find(params[:id])
    @trustee.update(trustee_params)
  end

  private

  def trustee_params
    params.require(:trustee).permit(:name, :street_address, :city, :state, :zip, :phone, :email, :position)
  end
end
