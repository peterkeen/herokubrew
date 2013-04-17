class Libjpeg6b < HerokuBrew::Formula
  # the canonical location for libjpeg is
  # http://sourceforge.net/projects/libjpeg/files/libjpeg/6b/jpegsrc.v6b.tar.gz/download
  # Sourceforge doesn't seem to offer a url that'll simply redirect to a mirror; instead
  # it requires a JS-enabled browser.
  # I've chosen a mirror that should be relatively close to US-East.
  url 'http://iweb.dl.sourceforge.net/project/libjpeg/libjpeg/6b/jpegsrc.v6b.tar.gz'
  basedir 'jpeg-6b'

  def autoconf(options=[])
    options = options.join(" ")
    run("./configure --prefix=#{prefix} #{options}")
    run("make")
    run("mkdir -p #{prefix}/bin")
    run("mkdir -p #{prefix}/man/man1")
    run("make install")
  end
end
