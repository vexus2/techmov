class MylistDetailsController < ApplicationController
  # GET /mylist_details
  # GET /mylist_details.json
  def index
    @mylist_details = MylistDetail.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @mylist_details }
    end
  end

  # GET /mylist_details/1
  # GET /mylist_details/1.json
  def show
    @mylist_detail = MylistDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mylist_detail }
    end
  end

  # GET /mylist_details/new
  # GET /mylist_details/new.json
  def new
    @mylist_detail = MylistDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mylist_detail }
    end
  end

  # GET /mylist_details/1/edit
  def edit
    @mylist_detail = MylistDetail.find(params[:id])
  end

  # POST /mylist_details
  # POST /mylist_details.json
  def create
    @mylist_detail = MylistDetail.new(params[:mylist_detail])

    respond_to do |format|
      if @mylist_detail.save
        format.html { redirect_to @mylist_detail, notice: 'Mylist detail was successfully created.' }
        format.json { render json: @mylist_detail, status: :created, location: @mylist_detail }
      else
        format.html { render action: "new" }
        format.json { render json: @mylist_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /mylist_details/1
  # PUT /mylist_details/1.json
  def update
    @mylist_detail = MylistDetail.find(params[:id])

    respond_to do |format|
      if @mylist_detail.update_attributes(params[:mylist_detail])
        format.html { redirect_to @mylist_detail, notice: 'Mylist detail was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @mylist_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mylist_details/1
  # DELETE /mylist_details/1.json
  def destroy
    @mylist_detail = MylistDetail.find(params[:id])
    @mylist_detail.destroy

    respond_to do |format|
      format.html { redirect_to mylist_details_url }
      format.json { head :no_content }
    end
  end

  def add()
    _execute(params[:user_id], params[:movie_id], 0)
    @movie_id = params[:movie_id]
    render
  end

  def delete()
    _execute(params[:user_id], params[:movie_id], 1)
    @movie_id = params[:movie_id]
    render
  end

  private
  def _execute(user_id, movie_id, del_flg)
    mylist_detail = MylistDetail.new(
        movie_id:    movie_id,
        omniuser_id: user_id,
        del_flg:     del_flg
    )
    mylist_detail.save
  end
end
