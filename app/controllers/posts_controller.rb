class PostsController < ApplicationController
  include DestroyWithUndoResponse

  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  def index
    @posts = Post.active.all
  end

  # GET /posts/1
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        flash = {
          title: "#{@post.title} was successfully created.",
          body: 'You can go to the edit page with the button below.',
          action: { url: edit_post_path(@post), method: 'get', name: 'Edit' }
        }
        format.html { redirect_to posts_url, success: flash }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /posts/1
  def update
    respond_to do |format|
      if @post.update(post_params)
        flash = {
          title: "#{@post.title} was successfully updated.",
          body: 'You can view it with the button below.',
          action: { url: post_path(@post), method: 'get', name: 'View' }
        }
        format.html { redirect_to posts_url, success: flash }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /posts/1
  def destroy
    post = Post.active.find(params[:id])
    job_id = post.schedule_destroy
    destroy_with_undo_response(record: post, job_id: job_id, redirect: posts_path)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title)
  end
end
