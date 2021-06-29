class GpathwaysController < ApplicationController
  protect_from_forgery
  before_action :authenticate_user!, except: [:index] #person who don't be logined can see only pathway list.
  before_action :set_gpathway, only: [:show, :edit, :update, :destroy,  :upload]
  
  def index
    @gpathways = Gpathway.all
    session[:glycan_id] = params[:glycan_motif_id]
    #puts session[:glycan_id], params[:glycan_motif_id]
  end

  def show
    require 'net/http'
    require 'uri'
    if params[:download]
      send_file "public/docs/reaction_input.xlsx"
    end
    
    @greaction = Greaction.new
    @grxn_count = @gpathway.greactions.count
    #puts "count: #{ @grxn_count}"
    gpath_uri = URI.parse('http://localhost:3002/sparqlist/api/pathway_visualization?pathway_id=' + 
                @gpathway.id.to_s )
        Net::HTTP.get(gpath_uri)  #해당 pathway id를 sparqlist로 보냄
    json_pw_g = Net::HTTP.get(gpath_uri)      #sparlist의 결과를 받고 json 형식으로 바꿔주자.
    @pw_rxn_array = JSON.parse(json_pw_g)
    #puts "json: #{@pw_rxn_array}"
  end

  def new
    @gpathway = Gpathway.new
  end

  def create
    @gpathway = Gpathway.new(gpathway_params)
    @gpathway.user_id = current_user.id
    #puts params[:gpathway_bind_backbone][:value]
    if @gpathway.save
      redirect_to gpathway_path(@gpathway), notice: "Your pathway is successfully saved." 
    else
      render :new
    end
  end

  def edit
    if @gpathway.user_id != current_user.id
       #redirect_to gpathways_path, alert: 'You do not have authority to edit.'
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @gpathways = Gpathway.all
      if @gpathway.update(gpathway_params)
        redirect_to gpathway_path(@gpathway), notice: "Your pathway is edited."
      else
        render :edit
      end
  end

  def destroy
     @gpathway.destroy
     title = @gpathway.title
     
     if @gpathway.destroy
       flash[:notice] = "#{title}\" pathway was deleted successfully."
       redirect_to gpathways_path
     else 
       flash[:error] = "There was an error deleting the pathway."
       render 'gpathways/index'
     end
  end

  def upload
    require 'roo'
    if params[:fileupload].present?
      file_path = params[:fileupload].path
      file_data = Roo::Spreadsheet.open(file_path)
      head = file_data.row(1)
      file_rxn_array = []
      file_data.each_with_index do |row, idx|
        next if idx == 0
        @rxn_data = Hash[[head, row].transpose]
        @rxn_string = Hash[@rxn_data.map { |k, v| [k, v.to_s]}]
        file_rxn_array.push(@rxn_string)  
      end
      file_rxn_array.each do |grxn|
        @gpathway.greactions.create(
          rxnid: grxn["RXN NO."].to_s,
          reactant: grxn["Reactant Glycan"].to_s,
          reactant_img: grxn["Reactant GlyTouCan ID"],
          enzyme_name: grxn["Enzyme_Name"],
          enzyme_onto_id: grxn["EC number"],
          sugar_nt: grxn["Sugar Monocyte"],
          product_img: grxn["Product GlyTouCan ID"],
          product: grxn["Product GlyTouCan"].to_s,
          cellular_locate: grxn["Cellular Compartment"],
          gpathway_id: @gpathway,
          sugar_onto_id: grxn["Sugar ID(PubChem)"].to_s,
          cellcomp_onto_id: grxn["Cell_comp_GO"].to_s
          )
      end
      #puts Greaction.last.gpathway_id
    end
  end

  private
  def set_gpathway
    @gpathway = Gpathway.find(params[:id])  
  end
  
  def gpathway_params
    params.require(:gpathway).permit(:title, :description, :species, :species_id, :pw_category, :pw_category_id, :tissue, :tissue_id, :cell_line, :cell_line_id, :bind_backbone, :disease, :disease_id, :fileupload)
  end
end
