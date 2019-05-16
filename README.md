# Everything::Blog

Generate an HTML site for a blog of markdown pieces in your `everything` repo.

## Setup

```
bundle install --path=.bundle
```

Must define these environment variables:

- `EVERYTHING_PATH` - the full path to your everything repo.
- `BLOG_OUTPUT_PATH` - the full path to write the blog's HTML files
- `TEMPLATES_PATH` - the full path of the folder where the HTML templates for
  the blog are stored

You can create a `.env` file with these values, if you want.

## Usage

```
bin/eb generate
```

Make it easier to use by putting this in your .zshrc:

```
# For everything-blog
export PATH=$PATH:/Users/kyle/Dropbox/code/kyletolle/everything-blog/bin
alias eb="BUNDLE_GEMFILE=/Users/kyle/Dropbox/code/kyletolle/everything-blog/Gemfile bundle exec eb ${@:2}"
```

If you move time zones but want to keep generating dates the same way, you can override the timezone setting:

```
TZ='US/Mountain' bin/eb generate
```

## Viewing

To see the html output in the browser, from the root of this project do:

```
http-server output 3000
```

## License

MIT

