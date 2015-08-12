class Admin::PostsController < Admin::BaseController
  before_filter :load_post, only: [:edit, :update, :destroy]
  after_filter :cleanup_cached_pages
  
  def index
    @posts = Post.page(params[:page])
  end

  def new
    @post = Post.new
  end

  def edit; end

  def create
    @post = Post.new(post_params)
    if @post.save
      flash[:notice] = 'Post created'
      redirect_to action: :index
    else
      render :new
    end
  end

  def update
    if @post.update_attributes(post_params)
      expire_fragment("post_#{@post.id}_content")
      flash[:notice] = 'Post updated'
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to action: :index
  end

  private
  def post_params
    params.require(:post).permit(:title, :content)
  end

  def load_post
    @post = Post.friendly.find(params[:id])
  end

  def cleanup_cached_pages
    expire_page controller: 'posts', action: 'index'
  end
end
