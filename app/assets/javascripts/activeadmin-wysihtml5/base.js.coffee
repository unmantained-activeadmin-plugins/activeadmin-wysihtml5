#= require activeadmin-wysihtml5/wysihtml5.min
#= require activeadmin-wysihtml5/parser_rules
#= require activeadmin-wysihtml5/fileuploader
#= require activeadmin-wysihtml5/jquery.paginate.min

(($) ->
  $.fn.activeadmin_wysihtml5 = (options) ->
    this.each ->
      activeadmin_wysihtml5 = $(this)
      textarea_id = activeadmin_wysihtml5.find('textarea').attr('id')
      toolbar_id  = activeadmin_wysihtml5.find('.toolbar').attr('id')

      editor = new wysihtml5.Editor(textarea_id, {
        toolbar: toolbar_id,
        stylesheets: "/assets/activeadmin-wysihtml5/wysiwyg.css",
        parserRules: wysihtml5ParserRules
      })

      image_dialog = activeadmin_wysihtml5.find('[data-wysihtml5-dialog="insertImage"]')

      # Clears and hides the asset container
      clear_assets = ->
        activeadmin_wysihtml5.find('#asset_uploader').hide()
        image_dialog.find('.assets_container').html('').hide()
        image_dialog.find('.asset_scale_selection').hide()

      # Will re-load and re-render the assets
      load_assets = (done=null) ->
        container    = image_dialog.find('.assets_container')
        save_button  = image_dialog.find('a[data-wysihtml5-dialog-action="save"]')

        # Helper method for setting an input field within the dialog
        setDialogInput = (field, val) ->
          f = image_dialog.find("[data-wysihtml5-dialog-field='#{field}']")
          f.val(val)

        activeadmin_wysihtml5.find('#asset_uploader').show()
        $.getJSON '/admin/assets.json', (data) ->
          list = $('<ul class="page_content"></ul>')

          $.each data, (i, asset) ->
            tag = $("""
            <li class="asset">
              <img data-image-width="#{asset.dimensions.width}"
                data-image-height="#{asset.dimensions.height}"
                title="#{asset.dimensions.width}px x #{asset.dimensions.height}px"
                src="#{asset.thumb_url}" />
            </li>
            """)
            tag.find('img').data('image-src', asset.source_url)
            list.append(tag)

          container.append(list).show()
          container.append($('<div class="page_navigation"></div>'))
          container.paginate
            items_per_page: 10
            show_first: false
            show_last: false

          image_dialog.find('.asset_scale_selection').show()

          selectedScale = ->
            image_dialog.find('input[name="asset_scale"]:checked').data('scale')

          populateSrc = (el) ->
            scale = selectedScale()
            container.find('.asset').removeClass('active')
            src = $(el).data('image-src')[scale]
            setDialogInput 'src', src
            $(el).parent().addClass('active')

          image_dialog.find('input[name="asset_scale"]').click (e) ->
            populateSrc(image_dialog.find('.asset.active img')[0])

          container.find('img').
            click((e) ->
              populateSrc(this)
            ).
            dblclick((e) ->
              fireEvent = (element, event) ->
                if (document.createEvent)
                  # dispatch for firefox + others
                  evt = document.createEvent("HTMLEvents")
                  evt.initEvent(event, true, true ); # event type,bubbling,cancelable
                  return !element.dispatchEvent(evt)
                else
                  # dispatch for IE
                  evt = document.createEventObject()
                  return element.fireEvent('on'+event, evt)

              fireEvent save_button[0], 'click'
            )
        done() if done

      # HTML 5 Uploading
      uploader = new qq.FileUploader
        element: document.getElementById('asset_uploader'),
        action: '/admin/assets.json'
        onComplete: ->
          clear_assets()
          load_assets()

      editor.on 'show:dialog', (dialog) ->
        image_input = image_dialog.find('input[data-wysihtml5-dialog-field="src"]')
        if dialog.command == 'insertImage'
          clear_assets()
          load_assets() if image_input.val() == 'http://'

  $ -> $('.activeadmin-wysihtml5').activeadmin_wysihtml5()
)(jQuery)

