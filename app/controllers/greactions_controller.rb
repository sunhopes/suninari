class GreactionsController < ApplicationController
  def new
    @gpathway = Gpathway.find(params[:gpathway_id])
    @greaction = Greaction.new
    @greactions = Greaction.all
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def create
    @gpathway = Gpathway.find(params[:gpathway_id])
    @greaction = @gpathway.greactions.create(greaction_params)
    redirect_back(fallback_location: root_path)
    
    # redirect_to gpathway_path(@gpathway)  
  end
  
  def destroy
    @gpathway = Gpathway.find(params[:gpathway_id])
    @greaction = @gpathway.greactions.find(params[:id])
    title = @greaction.rxnid
    
    if @greaction.destroy
      flash[:notice] = "\"#{title}\" was deleted successfully."
      redirect_back(fallback_location: root_path)
    else
      flash[:error] = "There was an error deleting the reaction."
      render 'gpathways/show'
    end
  end

  def edit
    @gpathway = Gpathway.find(params[:gpathway_id])
    @greaction = @gpathway.greactions.find(params[:id])
    #@greaction = Greaction.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update 
    @gpathway = Gpathway.find(params[:gpathway_id])
    @greaction = @gpathway.greactions.find(params[:id])
    if @greaction.update(greaction_params)
      redirect_back(fallback_location: root_path) 
    else
      flash[:error] = "There was an error editing the reaction."
      render 'gpathways/show'
    end
  end

  private
 
  def greaction_params
    params.require(:greaction).permit(:rxnid, :reactant, :enzyme_name, :sugar_nt, :product, :cellular_locate, :article_id)

  end
end
