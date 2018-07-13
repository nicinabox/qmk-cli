require 'tempfile'

class Makefile
  def initialize(keyboard, include_makefile)
    @keyboard = keyboard
    @include_makefile = include_makefile
    @file = write
  end

  def get(variable)
    output = run variable
    _, value = parse output
    value
  end

  private
  def write
    file = Tempfile.new('makefile')
    file.write contents
    file.close
    file
  end

  def run(variable)
    p `make -f #{@file.path} -f #{LIB_PATH}/Makefile print-#{variable.to_s.upcase} KEYBOARD=#{@keyboard} KEYMAP=default`
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
