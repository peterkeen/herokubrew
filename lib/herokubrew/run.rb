module HerokuBrew::Run
  def run(*args)
    unless system(*args)
      exit $?.exitstatus || 1
    end
  end
end  
