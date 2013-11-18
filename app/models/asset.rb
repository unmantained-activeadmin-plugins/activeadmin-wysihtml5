class Asset < ActiveRecord::Base
  image_accessor :storage

  def percentage_thumb_url(size)
    width = (storage.width * size).ceil
    height = (storage.height * size).ceil
    storage.thumb("#{width}x#{height}").url
  end

  def thumb_url
    storage.thumb("100x100#").url
  end

  def as_json(options = {})
    {
      dimensions: {
        width: storage.width,
        height: storage.height
      },
      thumb_url: thumb_url,
      source_url: {
        full: storage.url,
        three_quarters: percentage_thumb_url(0.75),
        half: percentage_thumb_url(0.5),
        one_quarter: percentage_thumb_url(0.25)
      }
    }
  end
end

