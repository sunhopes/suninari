class GpathwaysController < ApplicationController
  before_action :authenticate_user!, except: [:index] #person who don't be logined can see only pathway list.
  def index
    @gpathways = Gpathway.all
  end

  def show
    @gpathway = Gpathway.find(params[:id])
    @greaction = Greaction.new   #used by the form of greaction
    
  end

  def new
    @gpathway = Gpathway.new
  end

  def create
    @gpathway = Gpathway.new(gpathway_params)
    @gpathway.user_id = current_user.id
    if @gpathway.save
      redirect_to gpathway_path(@gpathway), notice: "Your pathway is successfully saved." #@gpathway는 id
    else
      render :new
    end
  end

  def edit
    @gpathway = Gpathway.find(params[:id])
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
    @gpathway = Gpathway.find(params[:id])
      if @gpathway.update(gpathway_params)
        redirect_to gpathway_path(@gpathway), notice: "Your pathway is edited."
      else
        render :edit
      end
  end

  def destroy
     @gpathway = Gpathway.find(params[:id]) 
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

  private
  def gpathway_params
    params.require(:gpathway).permit(:title, :description, :species, :tissue, :cell_line, :bind_backbone)

  end
end
