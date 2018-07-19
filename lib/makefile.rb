require 'tempfile'

class Makefile
  def initialize(include_makefile)
    @include_makefile = include_makefile
    @file = write
  end

  def get(variable)
    output = run variable
    _, value = parse output
    value
  end

  def dry_run(command)
    `make -n -f #{@include_makefile} #{command}`
  end

  private
  def write
    file = Tempfile.new('makefile')
    file.write contents
    file.close
    file
  end

  def run(variable)
    `make -f #{@file.path} -f #{@include_makefile} print-#{variable.to_s.upcase}`
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
