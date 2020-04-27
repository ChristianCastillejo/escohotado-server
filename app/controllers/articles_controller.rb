class ArticlesController < ApplicationController
  include Response
  include ExceptionHandler

  before_action :set_article, only: [:show, :update, :destroy]
  before_action :authorize_request, only: [:create, :update, :destroy]

  attr_reader :current_user

  # GET /articles
  def index
    render json: Article.all
  end

  # POST /articles
  def create
    @article = Article.create!(article_params)
    unless !params['tag']
      params['tag'].each do |t|
        tag = Tag.find_by(name: t["name"])
        @article.tags << tag
      end
    end
    render json: @article
  end

  # GET /articles/:id
  def show
    render json: @article
  end

  # PUT /articles/:id
  def update
    @article = Article.find(params[:id])
    
    if article_params['tag']
      @article.tags.clear
      article_params['tag'].each do |t|
        tag = Tag.find_by(name: t["name"])
        unless @article.tags.include? tag
          @article.tags << tag
        end
      end
    end

    @article.update(article_params.except(:tag))
    render json: @article
  end

  # DELETE /articles/:id
  def destroy
    @article.destroy
    head :no_content
  end

  def search_by_tags
    @articles = Article.all

    unless params["tags"] === ""
      tags = params["tags"].split(',')
      @articles = Article.joins(:tags)
      .where(tags: { name: tags })
      .group('articles.id')
      .having('count(*) = ?', tags.count)
    end

    unless params["search"] === "false"
      @articles = @articles.where("title_sp ILIKE ? or body_sp ILIKE ? or title_en ILIKE ? or body_en ILIKE ?", "%#{params["search"]}%", "%#{params["search"]}%", "%#{params["search"]}%", "%#{params["search"]}%")
    end

    render json: @articles
  end

  private

  def authorize_request
    @current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
  end

  def article_params
    # whitelist params
    params.require(:article).permit(:title_sp, :body_sp, :title_en, :body_en, :images, :date, :id, tag: [:name])
  end

  def set_article
    @article = Article.find(params[:id])
  end
end