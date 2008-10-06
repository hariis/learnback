class OpinionsController < ApplicationController
  before_filter :login_required , :except => :index
  #before_filter :authenticate
  layout "application"
  # GET /opinions
  # GET /opinions.xml
  
  def index
    
            #Get page to display
            pagenum = params[:page] ? params[:page] : session[:page]
            pagenum = pagenum ? pagenum : "1"
            #Get dept filter
            #If coming here after save, use the newly created opinion's data
            #else If coming from index page itself, get the selected data from the select box
            #else use the cookie data, which simulates where the user left off 
            new_opinion = flash[:new_op]
            if new_opinion
              @filter = new_opinion.dept
              pagenum = 1   #The new opinion is always on the first page
            else
              @filter = params[:filter] ? params[:filter] : session[:filter]
              @filter = @filter ? @filter : "1"
              pagenum = 1 if params[:filter] != session[:filter]        
            end
            if @filter == "7"              
              @went_well_opinions = Opinion.searchw_by_user( pagenum,current_user)
              @not_well_opinions =  Opinion.searchn_by_user( pagenum,current_user)
            else
               @went_well_opinions = Opinion.searchw( @filter, pagenum)
               @not_well_opinions =  Opinion.searchn( @filter, pagenum)
            end
           
            @opinions = Opinion.find(:all,  :order => "updated_at desc")

            #This is for display
             @depts = Opinion::DEPTS
             @filter_string = @depts.index(@filter)

            #Store the data
            session[:filter] = @filter
            session[:page] = pagenum
            
            #@ops_by_user = Opinion.search_all_by_user( "N" ,current_user )
            respond_to do |format|
              format.html # index.html.erb
              format.xml  { render :xml => @opinions }
              format.atom
            end   
  end

  # GET /opinions/1
  # GET /opinions/1.xml
  def show
    @opinion = Opinion.find(params[:id])
    depts = Opinion::DEPTS
     @dept_string = depts.index(@opinion.dept)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @opinion }
    end
  end
  def show_all
    @filter = params[:filter]
    @kind = params[:kind]
    
    if @filter == "7"              
      @opinions = Opinion.search_all_by_user( @kind ,current_user )
    else
       @opinions = Opinion.search_all( @filter, @kind  )
    end
            
    
    @depts = Opinion::DEPTS
    @filter_string = @depts.index(@filter)
  end
  def search
    @keywords = params[:tag]
    @opinions = []
    if @keywords != nil
        @opinions = Opinion.search( @keywords  )
    end
  end
  # GET /opinions/new
  # GET /opinions/new.xml
  def new
    @opinion = Opinion.new
    @depts = Opinion::DEPTS
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @opinion }
    end
  end

  # GET /opinions/1/edit
  def edit
    @opinion = Opinion.find(params[:id])
    @depts = Opinion::DEPTS
  end

  # POST /opinions
  # POST /opinions.xml
  def create
    @opinion = Opinion.new(params[:opinion])
    
    respond_to do |format|
      if @current_user.opinions << @opinion
        flash[:notice] = 'Opinion was successfully created.'
        flash[:new_op] = @opinion
        format.html { redirect_to(opinions_path) }
        format.xml  { render :xml => @opinion, :status => :created, :location => @opinion }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @opinion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /opinions/1
  # PUT /opinions/1.xml
  def update
    @opinion = Opinion.find(params[:id])

    respond_to do |format|
      if @opinion.update_attributes(params[:opinion])
        flash[:notice] = 'Opinion was successfully updated.'
        flash[:new_op] = @opinion
        format.html { redirect_to(opinions_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @opinion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /opinions/1
  # DELETE /opinions/1.xml
  def destroy
    @opinion = Opinion.find(params[:id])
    @opinion.destroy

    respond_to do |format|
      format.html { redirect_to(opinions_url) }
      format.xml  { head :ok }
    end
  end
  
  def voteup
     @opinion = Opinion.find(params[:id])
     current_votes = @opinion.votes
      @opinion.update_attribute(:votes, current_votes + 1)
      @opinion.record_voter(current_user.login)
  end
  protected
 
  def authenticate
      case request.format
      when Mime::XML, Mime::ATOM
            if user = authenticate_with_http_basic { |name, pass| User.authenticate(name, pass) }
                        #@current_user = user
            else
                        request_http_basic_authentication
            end
      else
            login_required #if action_name != 'index' 
            if logged_in?
              return true 
            else
              return false
            end
      end
  end
end
