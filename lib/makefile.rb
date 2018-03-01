require 'tempfile'

class Makefile
  def initialize(include_makefile)
    @include_makefile = include_makefile
    @file = Tempfile.new('makefile')

    write
  end

  def value(variable)
    output = run variable
    _, value = parse output
    value
  end

  private
  def write
    @file.write contents
    @file.close
  end

  def run(variable)
    `make -f #{@file.path} -f #{@include_makefile} print-#{variable.upcase}`
  end

  def parse(output)
    match = output.match /^(\w+)=(.+)/
    if match
      [match[1], match[2]]
    end
  end

  def contents
    <<-contents
.PHONY: print-%
print-%:
\t@echo '$*=$($*)'
    contents
  end
end
