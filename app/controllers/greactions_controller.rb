class GreactionsController < ApplicationController
  before_action :set_pwGpathway, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_pwGreaction, only: [:edit, :update, :destroy]

  def new
    @greaction = Greaction.new
    @g_id = session[:glycan_id]   #gpathways_index의 session에서 받아옴(이유를 알아야 한다. 왜 이곳으로 오지 않는가?!)
    @grxn_count = @gpathway.greactions.count
    if @grxn_count.to_i == 0
      @last_id = 1
      @receive_product = @g_id 
      #puts "product: #{@receive_product}"
    elsif @grxn_count.to_i != 0
      @reaction_last_id = @gpathway.greactions.last[:rxnid].to_i
      @last_id = @reaction_last_id + 1
      @receive_product = @gpathway.greactions.last[:product_img] 
    end
    
    respond_to do |format|
      format.html
      format.js
      #format.json { render json: json_file }
    end
  end
  
  def create
    require 'net/http'
    require 'uri'
    rnum = params[:rxnid]
    if rnum != 0
      new_params2 = greaction_params
        if params[:textype1] == 'glytoucanid'
          @reactant_img = greaction_params[:reactant]
        else  
          get_glycanid(greaction_params[:reactant], params[:textype1]) #함수호출  
        end
        new_params2[:reactant_img] = @reactant_img     # !!입력으로 받은 문자열을 TouCanID로 바꿔서 이 ID를 :reactant_img에 넣어주고 표시는 glycosmos image convert API를 이용하여 show 에서 한다.  
        if params[:textype2] == "glytoucanid"
          @product_img = greaction_params[:product]
        else  
          get_glycanid(greaction_params[:product], params[:textype2])
        end
        new_params2[:product_img] = @product_img   # !!입력으로 받은 문자열을 TouCanID로 바꿔서 이 ID를 :product_img에 넣어주고 표시는 glycosmos image convert API를 이용하여 show 에서 한다.
    end
    @greaction = @gpathway.greactions.create(new_params2)
    redirect_back(fallback_location: root_path)  
  end

  def edit
    @edit_react_touid = @greaction.reactant_img
    @edit_produdt_touid = @greaction.product_img

    respond_to do |format|
      format.html
      format.js
    end
  end

  def update 
    require 'net/http'
    require 'uri'
    rnum = params[:rxnid]
    if rnum != 0
      new_params2 = greaction_params
        if params[:textype1] == 'glytoucanid'
          @reactant_img = greaction_params[:reactant]
        else  
          get_glycanid(greaction_params[:reactant], params[:textype1]) #함수호출  
        end
        new_params2[:reactant_img] = @reactant_img     # !!입력으로 받은 문자열을 TouCanID로 바꿔서 이 ID를 :reactant_img에 넣어주고 표시는 glycosmos image convert API를 이용하여 show 에서 한다.  
        
        if params[:textype2] == "glytoucanid"
          @product_img = greaction_params[:product]
        else  
          get_glycanid(greaction_params[:product], params[:textype2])
        end
        new_params2[:product_img] = @product_img   # !!입력으로 받은 문자열을 TouCanID로 바꿔서 이 ID를 :product_img에 넣어주고 표시는 glycosmos image convert API를 이용하여 show 에서 한다.
    end
    if @greaction.update(new_params2)
      redirect_back(fallback_location: root_path) 
    else
      flash[:error] = "There was an error editing the reaction."
      render 'gpathways/show'
    end
  end
  
  def destroy
    title = @greaction.rxnid
    
    if @greaction.destroy
      flash[:notice] = "\"#{title}\" reaction was deleted successfully."
      redirect_back(fallback_location: root_path)
    else
      flash[:error] = "There was an error deleting the reaction."
      render 'gpathways/show'
    end
  end

  def rdf_upload
    require 'net/http'
    require 'uri'
    @gpathway = Gpathway.find(params[:gpathway_id])
    @greactions = @gpathway.greactions.all
    reactionArray = @gpathway.greaction_ids.join(',') #배열을 string으로 만듬.(join)
    #puts "id_array: #{reactionArray}"
    
    @greactions.each do |reaction|
      
      reaction_uri = URI.parse('http://localhost:3002/sparqlist/api/gpathway_test1?' + 
        '&reaction_id=' + reaction.id.to_s  +
        '&reactant_name=' + reaction.reactant +
        '&reactant_touid=' + reaction.reactant_img +
        '&product_touid=' + reaction.product_img +
        '&product_name=' + reaction.product +
        '&enzyme_id=' + reaction.enzyme_onto_id +
        '&enzyme_name=' + reaction.enzyme_name +
        '&sugar_id=' + reaction.sugar_onto_id +
        '&sugar_name=' + reaction.sugar_nt +
        '&cell_locate=' + reaction.cellular_locate +
        '&cell_locate_id=' + reaction.cellcomp_onto_id 
        )
      Net::HTTP.get(reaction_uri)
    end
    gpathway_uri = URI.parse('http://localhost:3002/sparqlist/api/gpathway_test1?' + 
        '&reactionIds=' + reactionArray +
        '&gpathway_name=' + @gpathway.title +
        '&gpathway_id=' + @gpathway.id.to_s  +
        '&gpathway_comment=' + @gpathway.description +
        '&gpathway_tissue_id=' + @gpathway.tissue_id +
        '&gpathway_tissue_name=' + @gpathway.tissue +
        '&gpathway_cell_name=' + @gpathway.cell_line +
        '&gpathway_cell_id=' + @gpathway.cell_line_id +
        '&gpathway_taxon_name=' + @gpathway.species +
        '&gpathway_taxon_id=' + @gpathway.species_id +
        '&gpathway_pw_category=' + @gpathway.pw_category +
        '&gpathway_pw_category_id=' + @gpathway.pw_category_id +
        '&gpathway_pw_disease=' + @gpathway.disease +
        '&gpathway_pw_disease_id=' + @gpathway.disease_id 
        )
      Net::HTTP.get(gpathway_uri)
    #puts "URI: #{gpathway_uri}"
    @last_product = @gpathway.greactions.last[:product_img]      
  end

  private
  def set_pwGpathway
    @gpathway = Gpathway.find(params[:gpathway_id]) 
  end
  def set_pwGreaction
    @greaction = @gpathway.greactions.find(params[:id]) 
  end
  def greaction_params
    params.require(:greaction).permit(:sugar_onto_id, :sugar_id, :rxnid, :reactant, :enzyme_name, :sugar_nt, :product, :cellular_locate, :enzyme_onto_id, :cellcomp_onto_id, :gpathway_id)
  end
  def get_glycanid(param_glycan, text_type)
    require 'net/http'
    require 'uri'
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
