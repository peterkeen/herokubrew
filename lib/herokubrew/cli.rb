require 'thor'
require 'tmpdir'
require 'aws/s3'
require 'digest/sha1'

class HerokuBrew::CLI < Thor

  include HerokuBrew::Run

  option :prefix, :type => :string, :default => '/app/.brew'

  desc "build FORMULA", "Build a forumla"
  def build(formula)
    form = HerokuBrew::Formula.load(formula, options[:prefix])

    deps = form.class.dependencies
    unless deps.nil?
      deps.dup.each do |dep|
        dep_formula = HerokuBrew::Formula.load(formula, options[:prefix])
        deps = (dep_formula.class.dependencies || []) + deps
      end
    end

    deps.uniq.each do |dep|
      puts "Building dependency #{dep}"
      dep_formula = HerokuBrew::Formula.load(dep, options[:prefix])
      dep_formula.build
    end

    puts "Building #{formula}"
    form.build

    filename = "#{formula}.tar.bz2"

    puts "Generating archive"
    archive_base = options[:prefix].gsub(/^\/app\//, '')
    run("tar cjf #{filename} #{archive_base}")

    puts "Uploading archive"
    AWS::S3::Base.establish_connection!(
      :access_key_id => ENV['AMAZON_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AMAZON_SECRET_ACCESS_KEY']
    )

    shasum = File.open(filename) do |f|
      Digest::SHA1.hexdigest(f.read)
    end

    archive_filename = "#{formula}.#{shasum}.tar.bz2"

    AWS::S3::S3Object.store(
      archive_filename,
      File.open(filename),
      ENV['AMAZON_BUCKET'],
      :content_type => 'application/x-bzip2',
      :access => :public_read
    )

    puts "URL: http://#{ENV['AMAZON_BUCKET']}.s3.amazonaws.com/#{archive_filename}"

  end

end
