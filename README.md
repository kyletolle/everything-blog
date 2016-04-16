# Everything::Blog

Generate an HTML site for a blog of markdown pieces in your `everything` repo.

## Setup

Must define these environment variables:

- `EVERYTHING_PATH` - the full path to your everything repo.
- `HTML_OUTPUT_PATH` - the full path to write the blog's HTML files
- `TEMPLATE_PATH` - the full path of the ERB HTML template to use for the blog

## Usage

```
bin/eb generate your-post-name-here
```

Make it easier to use by putting this in your .zshrc:

```
# For everything-blog
export PATH=$PATH:/Users/kyle/Dropbox/code/kyletolle/everything-blog/bin
alias eb="BUNDLE_GEMFILE=/Users/kyle/Dropbox/code/kyletolle/everything-blog/Gemfile bundle exec eb ${@:2}"
```

## Viewing

To see the html output in the browser, from the root of this project do:

```
http-server output 3000
```

## License

MIT

