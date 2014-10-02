class Api::V1::PostsController < ApplicationController
  before_action :get_post, only: :update
  before_action :token_authentication, only: [:create, :update]
  respond_to :json

  def index
    respond_with(Post.all)
  end

  def create
    post = Post.new(post_params)
    if post.save
      respond_with(post, location: api_v1_post_url(post))
    else
      respond_with(post)
    end
  end

  def update
    @post.update_attributes(post_params)
    respond_with(@post)
  end

  private

  def post_params
    params.fetch(:post, {}).permit(:title, :content)
  end

  def get_post
    @post = Post.find_by_id(params[:id])
    render json: {error: 'The post you were looking for could not be found'}, status: 404 unless @post
  end

  def token_authentication
    authenticate_or_request_with_http_token do |token, options|
      ApiKey.exists?(token: token)
    end
  end

end