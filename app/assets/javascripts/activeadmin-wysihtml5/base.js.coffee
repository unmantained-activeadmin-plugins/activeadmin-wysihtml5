#= require activeadmin-wysihtml5/wysihtml5.min
#= require activeadmin-wysihtml5/parser_rules
#= require activeadmin-wysihtml5/fileuploader
#= require activeadmin-wysihtml5/jquery.paginate.min

(($) ->

  $.fn.modal = (options) ->
    $overlay = $("#lean_overlay")
    if $overlay.length == 0
      $overlay = $("<div/>").attr(id: 'modal-overlay').appendTo("body")

    @each ->
      $content = $(@).appendTo("body")
      $overlay.show()

      height = $content.outerHeight()
      width = $content.outerWidth()

      $content.css(
        display: 'block'
        position: 'fixed'
        zIndex: 1200
        left: '50%'
        top: '50%'
        marginTop: - height * 0.5
        marginLeft: - width * 0.5
      ).show()

      $content.on 'click', '[data-modal=close]', ->
        $overlay.hide()
        $content.hide().remove()

  $.fn.activeAdminWysihtml5 = (options) ->
    this.each ->
      $editor = $(this)
      $toolbar = $editor.find('.toolbar')
      $textarea = $editor.find('textarea')

      editor = new wysihtml5.Editor($textarea.attr('id'), {
        toolbar: $toolbar.attr('id'),
        stylesheets: "/assets/activeadmin-wysihtml5/wysiwyg.css",
        parserRules: wysihtml5ParserRules
      })

      manageSource = ->
        $changeViewSelector = $toolbar.find("a[data-wysihtml5-action='change_view']")
        $changeViewSelector.click ->
          toolbar.find('a').not($changeViewSelector).toggleClass('disabled')
          $textarea.toggleClass('source')

      manageLinks = ->
        $button = $toolbar.find('a[data-wysihtml5-command=createLink]')

        $button.click ->
          activeButton = $(this).hasClass("wysihtml5-command-active")
          $modal = $editor.find(".modal-link")
          $field = $modal.find("input")
          $ok = $modal.find("[data-action=save]")

          $tab_contents = $modal.find("[data-tab]").hide()

          $tab_handles = $modal.find("[data-tab-handle]").click ->
            $tab_contents.hide()
            $($(@).attr("href")).show()
            $tab_handles.removeClass("active")
            $(@).addClass("active")
            false

          $ok.click ->
            $content = $tab_contents.filter(":visible")
            el = switch $content.attr("id")
              when "modal-link-url"
                href: $content.find("[name=url]").val()
                text: $content.find("[name=text]").val()
                rel: $content.find("[name=rel]").val()
                title: $content.find("[name=title]").val()
                target: (if $content.find("[name=blank]").is(":checked") then "_blank" else "")
              when "modal-link-email"
                href: "mailto:" + $content.find("[name=email]").val()
                text: $content.find("[name=text]").val()
              when "modal-link-anchor"
                id: $content.find("[name=anchor]").val()
                text: $content.find("[name=text]").val()

            editor.currentView.element.focus()
            editor.composer.commands.exec("createLink", el)

          if !activeButton
            $modal.modal()
            $tab_contents.find("[name=text]").val(editor.composer.selection.getText())
            $tab_handles.eq(0).click()
            false
          else
            true

      manageLinks()

      # imageDialog = activeadminWysihtml5.find('[data-wysihtml5-dialog="insertImage"]')

      # # Clears and hides the asset container
      # clearAssets = ->
      #   activeadminWysihtml5.find('#assetUploader').hide()
      #   imageDialog.find('.assetsContainer').html('').hide()
      #   imageDialog.find('.assetScaleSelection').hide()

      # # Will re-load and re-render the assets
      # loadAssets = (done=null) ->
      #   container    = imageDialog.find('.assetsContainer')
      #   saveButton  = imageDialog.find('a[data-wysihtml5-dialog-action="save"]')

      #   # Helper method for setting an input field within the dialog
      #   setDialogInput = (field, val) ->
      #     f = imageDialog.find("[data-wysihtml5-dialog-field='#{field}']")
      #     f.val(val)

      #   activeadminWysihtml5.find('#assetUploader').show()
      #   $.getJSON '/admin/assets.json', (data) ->
      #     list = $('<ul class="pageContent"></ul>')

      #     $.each data, (i, asset) ->
      #       tag = $("""
      #       <li class="asset">
      #         <img data-image-width="#{asset.dimensions.width}"
      #           data-image-height="#{asset.dimensions.height}"
      #           title="#{asset.dimensions.width}px x #{asset.dimensions.height}px"
      #           src="#{asset.thumbUrl}" />
      #       </li>
      #       """)
      #       tag.find('img').data('image-src', asset.sourceUrl)
      #       list.append(tag)

      #     container.append(list).show()
      #     container.append($('<div class="pageNavigation"></div>'))
      #     container.paginate
      #       itemsPerPage: 10
      #       showFirst: false
      #       showLast: false

      #     imageDialog.find('.assetScaleSelection').show()

      #     selectedScale = ->
      #       imageDialog.find('input[name="assetScale"]:checked').data('scale')

      #     populateSrc = (el) ->
      #       scale = selectedScale()
      #       container.find('.asset').removeClass('active')
      #       src = $(el).data('image-src')[scale]
      #       setDialogInput 'src', src
      #       $(el).parent().addClass('active')

      #     imageDialog.find('input[name="assetScale"]').click (e) ->
      #       populateSrc(imageDialog.find('.asset.active img')[0])

      #     container.find('img').
      #       click((e) ->
      #         populateSrc(this)
      #       ).
      #       dblclick((e) ->
      #         fireEvent = (element, event) ->
      #           if (document.createEvent)
      #             # dispatch for firefox + others
      #             evt = document.createEvent("HTMLEvents")
      #             evt.initEvent(event, true, true ); # event type,bubbling,cancelable
      #             return !element.dispatchEvent(evt)
      #           else
      #             # dispatch for IE
      #             evt = document.createEventObject()
      #             return element.fireEvent('on'+event, evt)

      #         fireEvent saveButton[0], 'click'
      #       )
      #   done() if done

      # # HTML 5 Uploading
      # uploader = new qq.FileUploader
      #   element: document.getElementById('assetUploader'),
      #   action: '/admin/assets.json'
      #   onComplete: ->
      #     clearAssets()
      #     loadAssets()

      editor.on 'show:dialog', (dialog) ->
        imageInput = imageDialog.find('input[data-wysihtml5-dialog-field="src"]')
        if dialog.command == 'insertImage'
          clearAssets()
          loadAssets() if imageInput.val() == 'http://'

  $ -> $('.activeadmin-wysihtml5').activeAdminWysihtml5()
)(jQuery)

