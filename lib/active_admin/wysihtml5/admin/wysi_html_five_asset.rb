ActiveAdmin.register WysiHtmlFiveAsset do

  index as: :grid do |asset|
    link_to(image_tag(asset.storage.thumb("100x100#").url), admin_asset_path(asset))
  end

  form do |f|
    f.inputs do
      f.input :storage, as: :dragonfly, input_html: { components: [:preview, :upload, :url, :remove ] }
    end
    f.actions
  end

  show do
    attributes_table do
      row('Dimensions') do
        "#{asset.storage.width}px x #{asset.storage.height}px"
      end
      row('Thumbnail') do
        image_tag(asset.thumb_url)
      end
      row('25%') do
        image_tag(asset.percentage_thumb_url(0.25))
      end
      row('50%') do
        image_tag(asset.percentage_thumb_url(0.5))
      end
      row('75%') do
        image_tag(asset.percentage_thumb_url(0.75))
      end
      row('Full Image') do
        image_tag(asset.storage.url)
      end
    end
  end

  controller do
    def permitted_params
      params.permit asset: [:storage, :retained_storage, :remove_storage, :storage_url]
    end
    def create
      # If an app is using Rack::RawUpload, it can just use
      # params['file'] and not worry with original_filename parsing.
      if params['file']
        @asset = WysiHtmlFiveAsset.new
        @asset.storage = params['file']

        if @asset.save!
          render json: { success: true }.to_json
        else
          render nothing: true, status: 500 and return
        end
      elsif params['qqfile']
        @asset = WysiHtmlFiveAsset.new
        io = request.env['rack.input']
        # throw io

        # def io.original_filename=(name) @original_filename = name; end
        # def io.original_filename() @original_filename; end

        # io.original_filename = params['qqfile']

        @asset.storage = Dragonfly::TempObject.new(io.respond_to?(:string) ? io.string : io.read)
        if @asset.save!
          render json: { success: true }.to_json
        else
          render nothing: true, status: 500 and return
        end
      else
        create!
      end
    end

  end
end
