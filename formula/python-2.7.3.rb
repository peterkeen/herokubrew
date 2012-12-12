class Python273 < HerokuBrew::Formula
  url     "http://www.python.org/ftp/python/2.7.3/Python-2.7.3.tar.bz2"
  basedir "Python-2.7.3"
  depends "sqlite3"

  def install
    autoconf(['--without-doc-strings'])
  end
end
