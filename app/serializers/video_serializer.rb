class VideoSerializer < ActiveModel::Serializer
  attributes :id, :title_sp, :title_en, :url, :description_sp, :description_en, :tags, :date
  has_many :tags
end
