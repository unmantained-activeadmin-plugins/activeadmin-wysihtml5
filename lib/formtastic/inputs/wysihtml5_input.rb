module Formtastic
  module Inputs
    class Wysihtml5Input < Formtastic::Inputs::TextInput

      def toolbar_blocks
        blocks = input_html_options[:blocks] || [:h2, :h3, :h4, :h5, :p]

        if blocks.any?
          template.content_tag(:li) do
            template.content_tag(:div, class: "editor-command blocks-selector") do
              template.content_tag(:span, I18n.t("wysihtml5.block_style")) <<
              template.content_tag(:ul) do
                blocks.map do |block|
                  template.content_tag(:li) do
                    template.content_tag(
                      :a,
                      I18n.t("wysihtml5.blocks.#{block}", default: block.to_s.titleize),
                      href: "javascript:void(0);",
                      data: {
                        wysihtml5_command: 'formatBlock',
                        wysihtml5_command_value: block
                    })
                  end
                end.join.html_safe
              end
            end
          end
        else
          "".html_safe
        end
      end

      def toolbar_commands
        command_groups = [
          [ :bold, :italic, :underline ],
          [ :ul, :ol, :outdent, :indent ],
          [ :link ],
          [ :image ],
          [ :source ]
        ]
        command_mapper = {
          link: 'createLink',
          image: 'insertImage',
          ul: 'insertUnorderedList',
          ol: 'insertOrderedList',
          source: 'change_view',
        }
        toolbar_commands = input_html_options[:commands] || [ :bold, :italic, :link ]

        command_groups.map do |group|
          commands = ''
          group.each do |command|
            if toolbar_commands.include? command
              wysihtml5_command = command_mapper[command.to_sym] || command.to_s
              title = I18n.t("wysihtml5.command.#{command}", default: command.to_s.titleize)
              commands << template.content_tag(
                :a,
                href: "javascript:void(0)",
                class: "editor-command #{command}",
                title: title,
                data: { wysihtml5_command: wysihtml5_command }
              ) do
                template.content_tag(:span, title)
              end
            end
          end
          if commands.present?
            template.content_tag(:li, commands.html_safe)
          else
            nil
          end
        end.compact.join.html_safe
      end

      def toolbar
        template.content_tag(:ul, id: "#{input_html_options[:id]}-toolbar", class: "toolbar") do
          toolbar_blocks << toolbar_commands
        end << toolbar_dialogs
      end

      def to_html
        input_wrapping do
          label_html <<
          template.content_tag(:div, class: 'activeadmin-wysihtml5') do
            toolbar <<
            builder.text_area(method, input_html_options)
          end
        end
      end

      def toolbar_dialogs
        html = <<-HTML
        <div data-wysihtml5-dialog="createLink" style="display: none">
          <label>
            Link:
            <input data-wysihtml5-dialog-field="href" value="http://">
          </label>
          <div class="action-group">
            <a data-wysihtml5-dialog-action="save" class="button">OK</a>
            <a data-wysihtml5-dialog-action="cancel">Cancel</a>
          </div>
        </div>
        <div data-wysihtml5-dialog="insertImage" style="display: none">
          <div id="asset_uploader">
            <noscript>
              <a href="/admin/assets/new">Upload &raquo;</a>
            </noscript>
          </div>
          <label>
            Image:
            <input data-wysihtml5-dialog-field="src" value="http://" />
          </label>
          <div class="assets_container">
          </div>
          <div class="asset_scale_selection">
            <label>Scale:</label>
            <label>
              100%
              <input data-scale="full" type="radio" name="asset_scale" checked="checked" />
            </label>
            <label>
              75%
              <input data-scale="three_quarters" type="radio" name="asset_scale" />
            </label>
            <label>
              50%
              <input data-scale="half" type="radio" name="asset_scale" />
            </label>
            <label>
              25%
              <input data-scale="one_quarter" type="radio" name="asset_scale" />
            </label>
          </div>
          <label>
            Align:
            <select data-wysihtml5-dialog-field="className">
              <option value="">default</option>
              <option value="wysiwyg-float-left">left</option>
              <option value="wysiwyg-float-right">right</option>
            </select>
          </label>
          <div class="action-group">
            <a data-wysihtml5-dialog-action="save" class="button">OK</a>
            <a data-wysihtml5-dialog-action="cancel">Cancel</a>
          </div>
        </div>
        HTML
        html.html_safe
      end

    end
  end
end
