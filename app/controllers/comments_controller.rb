class CommentsController < ApplicationController
  before_filter :load_opinion
  
  def load_opinion
    @opinion = Opinion.find(params[:opinion_id])
  end
  
  # GET /comments
  # GET /comments.xml
  def index
    @comments = @opinion.comments.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = @opinion.comments.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = @opinion.comments.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = @opinion.comments.find(params[:id])
  end

  # POST /comments
  # POST /comments.xml
  def create
    @comment = @opinion.comments.build(params[:comment])
    @comment.user_id = current_user.id
    respond_to do |format|
      if @opinion.comments << @comment
        flash[:notice] = 'Your Comment was successfully added.'
        format.html { redirect_to(@opinion) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        flash[:comment] = @comment
        format.html { redirect_to(@opinion) }        
        #format.html {render :action => "new"}
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = @opinion.comments.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        flash[:notice] = 'Comment was successfully updated.'
        format.html { redirect_to(@opinion, @comment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = @opinion.comments.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(opinion_comments_url) }
      format.xml  { head :ok }
    end
  end
end
