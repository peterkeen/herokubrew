class HerokuBrew::Formula

  include HerokuBrew::Run

  attr_reader :prefix

  class << self
    attr_reader :dependencies, :fetch_url, :base_dir, :patches

    def depends(name)
      @dependencies ||= []
      @dependencies << name
    end

    def patch(url)
      @patches ||= []
      @patches << url
    end

    def url(fetch_url)
      @fetch_url = fetch_url
    end

    def basedir(base)
      @base_dir = base
    end
  end

  def self.class_s name
    #remove invalid characters and then camelcase it
    name.capitalize.gsub(/[-_.\s]([a-zA-Z0-9])/) { $1.upcase } \
                   .gsub('+', 'x')
  end

  def self.load(name, prefix)
    require File.expand_path("../../../formula/#{name}", __FILE__)
    klass = const_get(class_s(name))
    klass.new(prefix)
  end

  def initialize(prefix)
    @prefix = prefix
  end

  def install
    autoconf
  end

  def autoconf(options=[])
    options = options.join(" ")
    run("./configure --prefix=#{prefix} #{options}")
    run("make")
    run("make install")
  end    
  
  def build
    dir = Dir.mktmpdir
    Dir.chdir dir do
      url = self.class.fetch_url
      puts "Fetching #{url}"
      if url.end_with?('bz2')
        tar = "tar xj"
      else
        tar = "tar xz"
      end
      run("curl --silent -L '#{url}' | #{tar}")
      Dir.chdir(self.class.base_dir) do
        (self.class.patches || []).each do |patch|
          run("curl --silent -L #{patch} | patch -p1")
        end
        install
      end
    end
  end

end
