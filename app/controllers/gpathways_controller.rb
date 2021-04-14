class GpathwaysController < ApplicationController
  before_action :authenticate_user!, except: [:index] #person who don't be logined can see only pathway list.
  before_action :set_gpathway, only: [:show, :edit, :update, :destroy, :rdf_register, :rdf_search]
  
  def index
    @gpathways = Gpathway.all
  end

  def show
    @greaction = Greaction.new
   
    # @lastRxn = Greaction.order("updated_at DESC").limit(1)  #테이블의 마지막에 입력한 정볼르 불러온다.
    # @reactionList = Hash.new
    # @lastRxn.each do |item|
    #   #@reactionList["id"] = item.id 
    #   @reactionList["RXNID"] = item.rxnid
    #   @reactionList["Reactant"] = item.reactant_img
    #   @reactionList["Enzyme"] = item.enzyme_name
    #   @reactionList["Sugar Nuclotide"] = item.sugar_nt
    #   @reactionList["Product"] = item.product_img
    #   @reactionList["Cell Location"] = item.cellular_locate
    # end
    
  end

  def new
    @gpathway = Gpathway.new
  
  end

  def create
    @gpathway = Gpathway.new(gpathway_params)
    @gpathway.user_id = current_user.id
    #puts params[:gpathway_bind_backbone][:value]
    if @gpathway.save
      redirect_to gpathway_path(@gpathway), notice: "Your pathway is successfully saved." #@gpathway는 id
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

  def download_file
    send_file "public/docs/input_Format.csv"
  end

  def upload
    file = params[:fileupload]
    name = file.original_filename
    session[:file_name] = name
    permit_file = ['.csv','.tsv','.txt']
    # @name_test = name
    if permit_file.include?(File.extname(name))
          File.open("public/docs/#{name}", 'wb') { |f| f.write(file.read) }
          @file_result = "#{name}"
    elsif
          @file_result = "Check your file format!"
    end
    require 'csv'
    # @line_count = File.readlines("public/docs/#{name}").size
    @rowArray = Array.new
    CSV.foreach("public/docs/#{name}", headers: true) do |row|
        @rowArray << row
    end
    session[:file_Array] = @rowArray
        # @f_text_test = @rowArray[0][1]
        # @f_fig_test = 'https://api.glycosmos.org/wurcs2image/experimental/png/binary/' + @f_text_test
    #@f_fig_api = 'https://api.glycosmos.org/wurcs2image/experimental/png/binary/'
  end

  def rdf_register
    require 'net/http'
    require 'uri'
    @greactions = Greaction.all

    # @greactions.each do |reaction|
    #   reaction_uri = URI.parse('http://localhost:3003/sparqlist/api/gpathway_test1?' + 
        
    #     '&reaction_id=' + reaction.rxnid.to_s +
    #     '&reactant_touid=' + reaction.reactant_img +
    #     'reactant_name=' + reaction.reactant  +
    #     '&product_touid=' + reaction.product_img +
    #     '&product_name=' + reaction.product +
    #     '&enzyme_id=' + reaction.enzyme_onto_id +
    #     '&enzyme_name=' + reaction.enzyme_name +
    #     '&sugar_id=' + reaction.sugar_onto_id +
    #     '&sugar_name=' + reaction.sugar_nt +
    #     '&sugar_name=' + reaction.sugar_nt +
    #     )
    #   Net::HTTP.get(reaction_uri)
    # end
    
    #redirect_to controller: :gpathways, action: :rdf_search
  end

  # def rdf_search

  # end


  private

  def set_gpathway
    @gpathway = Gpathway.find(params[:id]) 
  end
  def gpathway_params
    params.require(:gpathway).permit(:title, :description, :species, :species_id, :pw_category, :pw_category_id, :tissue, :tissue_id, :cell_line, :cell_line_id, :bind_backbone)

  end
end
