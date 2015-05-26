class MediumSerializer
  include RestPack::Serializer

  attributes :id, :href, :src, :content_type, :media_type, :external_link,
    :created_at, :metadata

  can_include :linked

  def href
    @model.location
  end

  def media_type
    @model.type
  end

  def src
    @model.url_for_format(@context[:url_format])
  end
end
