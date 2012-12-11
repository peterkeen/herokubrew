require 'thor'
require 'tmpdir'

class HerokuBrew::CLI < Thor

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

  end

end
