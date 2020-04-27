class VideosController < ApplicationController
  include Response
  include ExceptionHandler

  before_action :set_video, only: [:show, :update, :destroy]
  before_action :authorize_request, only: [:create, :update, :destroy]

  attr_reader :current_user

  # GET /videos
  def index
    render json: Video.all
  end

  # POST /videos
  def create
    @video = Video.create!(video_params)
    unless !params['tag']
      params['tag'].each do |t|
        tag = Tag.find_by(name: t["name"])
        @video.tags << tag
      end
    end
    render json: @video
  end

  # GET /videos/:id
  def show
    render json: @video
  end

  # PUT /videos/:id
  def update
    @video = Video.find(params[:id])

    if video_params['tag']
      @video.tags.clear
      video_params['tag'].each do |t|
        tag = Tag.find_by(name: t["name"])
        unless @video.tags.include? tag
          @video.tags << tag
        end
      end
    end

    @video.update(video_params.except(:tag))
    render json: @video
  end

  # DELETE /videos/:id
  def destroy
    @video.destroy
    head :no_content
  end

  def search_by_tags
    @videos = Video.all

    unless params["tags"] === ""
      tags = params["tags"].split(',')
      @videos = Video.joins(:tags)
      .where(tags: { name: tags })
      .group('videos.id')
      .having('count(*) = ?', tags.count)
    end

    unless params["search"] === "false"
      @videos = @videos.where("title_sp ILIKE ? or description_sp ILIKE ? or title_en ILIKE ? or description_en ILIKE ?", "%#{params["search"]}%", "%#{params["search"]}%", "%#{params["search"]}%", "%#{params["search"]}%")
    end

    render json: @videos
  end

  def random_video 
    @first_video = Video.find(Video.pluck(:id).sample)
    begin
      @second_video = Video.find(Video.pluck(:id).sample)
    end while @first_video === @second_video
    @videos = [@first_video, @second_video]
    render json: @videos
  end

  private

  def authorize_request
    @current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
  end

  def video_params
    # whitelist params
    params.require(:video).permit(:title_sp, :title_en, :description_sp, :description_en, :url, :date, tag: [:name])
  end

  def set_video
    @video = Video.find(params[:id])
  end
end