class Ruby193P327Falcon < HerokuBrew::Formula
  url     "http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p327.tar.gz"
  basedir "ruby-1.9.3-p327"
  patch   "https://raw.github.com/gist/4136373/1e17b7a6e69324c8167cf6b0a4e76a4100e0ed37/falcon-gc.diff"
  depends "libyaml"

  def install
    run "autoconf"
    autoconf(["--disable-install-doc"])
  end
end
