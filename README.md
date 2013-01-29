# `activeadmin-wysihtml5`

![activeadmin-wysihtml5 screenshot](https://raw.github.com/stefanoverna/activeadmin-wysihtml5/master/screenshot.png)

![activeadmin-wysihtml5 screenshot](https://raw.github.com/stefanoverna/activeadmin-wysihtml5/master/link_screenshot.png)

![activeadmin-wysihtml5 screenshot](https://raw.github.com/stefanoverna/activeadmin-wysihtml5/master/image_screenshot.png)

This is a wysiyg html editor for the [Active Admin](http://activeadmin.info/)
interface using [wysihtml5](https://github.com/xing/wysihtml5).

## Installation

```ruby
# Gemfile

gem 'activeadmin-dragonfly', github: 'stefanoverna/activeadmin-dragonfly'
gem 'activeadmin-wysihtml5', github: 'stefanoverna/activeadmin-wysihtml5'
```

Now install the migrations:

```bash
$ rake activeadmin_wysihtml5:install:migrations
$ rake db:migrate
```

## Usage
This gem provides you with a custom formtastic input called `:wysihtml5` to build out an html editor.
All you have to do is specify the `:as` option for your inputs.

**Example**

```ruby
ActiveAdmin.register Page do
  form do |f|
    f.inputs do
      f.input :title
      f.input :content, as: :wysihtml5, commands: [ :link ], blocks: [ :h3, :p]
    end

    f.buttons
  end
end
```

## Options

### `:commands`

* `:all`: all the available commands;
* `:basic`: bold, italic, ul, ol, link, image, source (default)
* `:barebone`: bold, italic, link, source
* an array with one or more of the following symbols: `:bold`, `:italic`, `:underline`, `:ul`, `:ol`, `:outdent`, `:indent`, `:link`, `:image`, `:source`

### `:blocks`

* `:all`: all the available blocks;
* `:basic`: just h3, h4, h5, p (default);
* `:barebone`: just p (default);
* an array with one or more of the following symbols: `:h1`, `:h2`, `:h3`, `:h4`, `:h5`, `:h6`, `:p`

### `:height`

* `:tiny`: 70px;
* `:small`: 90px;
* `:medium`: 170px (default);
* `:large`: 350px;
* `:huge`: 450px;
* an integer representing the height of the editor;

