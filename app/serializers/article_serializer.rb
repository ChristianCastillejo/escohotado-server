class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title_sp, :title_en, :body_sp, :body_en, :images, :tags, :date
  has_many :tags
end
