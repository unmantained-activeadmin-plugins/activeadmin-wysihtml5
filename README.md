# Active Admin WysiHTML5

This is a wysiyg html editor for the [Active Admin](http://activeadmin.info/)
interface using [wysihtml5](https://github.com/xing/wysihtml5).

## Installation

```ruby
# Gemfile

gem 'activeadmin-wysihtml5'
```

Now install the migrations:

```bash
$ rake active_admin_editor:install:migrations
$ rake db:migrate
```

## Usage
This gem provides you with a custom formtastic input called `:html_editor` to build out an html editor.
All you have to do is specify the `:as` option for your inputs.

**Example**

```ruby
ActiveAdmin.register Page do
  form do |f|
    f.inputs do
      f.input :title
      f.input :content, as: :wysihtml5, input_html: { commands: [ :link ], blocks: [ :h3, :p] }
    end

    f.buttons
  end
end
```
