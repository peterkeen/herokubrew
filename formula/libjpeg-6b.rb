class Libjpeg6b < HerokuBrew::Formula
  # the canonical location for libjpeg is
  # http://sourceforge.net/projects/libjpeg/files/libjpeg/6b/jpegsrc.v6b.tar.gz/download
  # Sourceforge doesn't seem to offer a url that'll simply redirect to a mirror; instead
  # it requires a JS-enabled browser.
  # I've chosen a mirror that should be relatively close to US-East.
  url 'http://iweb.dl.sourceforge.net/project/libjpeg/libjpeg/6b/jpegsrc.v6b.tar.gz'
  basedir 'jpegsrc.v6b'
end
