class GreactionsController < ApplicationController
  def new
    @gpathway = Gpathway.find(params[:gpathway_id])
    @greaction = Greaction.new

    respond_to do |format|
      format.html
      format.js
      #format.json { render json: json_file }
    end
  end
  
  def create
    @gpathway = Gpathway.find(params[:gpathway_id])
    require 'net/http'
    require 'uri'
    get_glycanid(greaction_params[:reactant], params[:textype1])
    
    new_params2 = greaction_params
    new_params2[:reactant_img] = @reactant_img     # !!입력으로 받은 문자열을 TouCanID로 바꿔서 이 ID를 :reactant_img에 넣어주고 표시는 glycosmos image convert API를 이용하여 show 에서 한다.
    #sid = params[:greaction][:sugar_id]
    sugarid = Sugar.find_by(id: params[:greaction][:sugar_id])
    @sugar = sugarid.name
    sugar_onto_id = sugarid.onto_id
    #p sid
    #p sugarid
    new_params2[:sugar_nt] = @sugar
    new_params2[:sugar_onto_id] = sugar_onto_id
    get_glycanid(greaction_params[:product], params[:textype2])
    new_params2[:product_img] = @product_img

    @greaction = @gpathway.greactions.create(new_params2)
    redirect_back(fallback_location: root_path)
    # redirect_to gpathway_path(@gpathway)  
  end
  
  def destroy
    @gpathway = Gpathway.find(params[:gpathway_id])
    @greaction = @gpathway.greactions.find(params[:id])
    title = @greaction.rxnid
    
    if @greaction.destroy
      flash[:notice] = "\"#{title}\" reaction was deleted successfully."
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
    params.require(:greaction).permit(:sugar_id, :rxnid, :reactant, :enzyme_name, :sugar_nt, :product, :cellular_locate)

  end

  def get_glycanid(param_glycan, text_type)
    if param_glycan.present?
      param_text = text_type
      if param_text == 'linearcode'
        str  = 'https://api.glycosmos.org/glycanformatconverter/2.5.2/linearcode2wurcs/' + param_glycan
        uri = URI.parse(str)
      elsif param_text == 'iupaccondensed'
        str = 'https://api.glycosmos.org/glycanformatconverter/2.5.2/iupaccondensed2wurcs/' + param_glycan
        uri = URI.parse(str)
      elsif param_text == 'iupacextended'
        str = 'https://api.glycosmos.org/glycanformatconverter/2.5.2/iupacextended2wurcs/' + param-glycan
        uri = URI.parse(str)
      end
      response = Net::HTTP.get(uri)       # URI of glyTouCan_ID
      response_id = JSON.parse(response)  # WURCS and GlyTouCan_ID
        if param_glycan == greaction_params[:reactant]
          if response_id.kind_of?(Hash)
            @reactant_img = response_id['id']    # only GlyTouCan_ID
          else
            @reactant_img = response_id['No GlyTouCan ID']
          end
        elsif param_glycan == greaction_params[:product]
          if response_id.kind_of?(Hash)
            @product_img = response_id['id']    # only GlyTouCan_ID
          else
            @product_img = response_id['No GlyTouCan ID']
          end
        end
    end
  end
end
