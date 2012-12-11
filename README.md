# HerokuBrew


*This is a proof of concept. Use it at your own risk.*

HerokuBrew is a build system for Heroku inspired by [Homebrew](https://github.com/mxcl/homebrew) and Kenneth Reitz's [python-versions](https://github.com/kennethreitz/python-versions).

## Usage

```
$ git clone https://github.com/peterkeen/herokubrew
$ cd herokubrew
$ heroku create
$ git push heroku master
$ heroku run brew build <formula name>
```

## Writing Formulas

Formulas are Ruby subclasses of `HerokuBrew::Formula`. Here's a simple example (located in `formula/libyaml.rb`):

```
class Libyaml < HerokuBrew::Formula
  url "http://pyyaml.org/download/libyaml/yaml-0.1.4.tar.gz"
  basedir "yaml-0.1.4"
end
```

Formula use a simple DSL:

* `url`: The URL of a tarball to fetch. This can either be a `.tar.gz` for a `.tar.bz2`.
* `basedir`: The directory that the tarball extracts into.
* `depends`: The name of a formula to depend on. This can be specified multiple times.
* `patch`: The URL of of a patch to apply after extracting the tarball. This will be fed to `patch -p1`

A formula can optionally specify an `install` step like this:

```
class ExampleFormula < HerokuBrew::Formula
  url "http://example.com/foo.tar.gz"
  basedir "foo"

  def install
    run("./configure --prefix=#{prefix}")
    run("make")
    run("make install")
  end
end
```

Note that if your formula does not specify an install step the `autoconf` steps (`configure`, `make`, `make install`) will be run automatically. You can default to these either by calling `super` or `autoconf` in your `install`. `prefix` will be provided for you, and can be overridden when calling `brew build` like this:

```
$ heroku run brew build <formula name> --prefix=someprefix
```

## Class and Formula Naming

Formula file names map to classes like this:

* Each string of alpha characters is capitalized
* Non-alphanumeric characters are stripped

So, for example, the file `ruby-1.9.3-p327-falcon` maps to `Ruby193P327Falcon`.

## Contributing

* Fork the repo
* Make your changes
* Submit a pull request