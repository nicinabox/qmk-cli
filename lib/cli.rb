require 'optparse'
require 'firmware'

USAGE = <<-USAGE
  Usage:
    qmk COMMAND [options]

  Commands:
    flash KEYBOARD    Flash a keyboard
    build KEYBOARD    Compile a keyboard
    clean [KEYBOARD]  Cleans up output folders so things compile from scratch
    keyboards         List available keyboards (scope with --keymap)
    setup             Clone QMK firmware and checkout latest tag
    update            Update QMK firmware to latest tag

  Options:
USAGE

module QMK
  class CLI
    def initialize(args)
      @options = parser(args)
      command, keyboard = args
      @firmware = Firmware.new(keyboard, @options[:keymap], config)

      command and self.send(parse_command(command))
    end

    def setup
      @firmware.setup
    end

    def update
      @firmware.update
      @firmware.update_submodules
    end

    def build
      @firmware.make
    end

    def flash
      @firmware.make @firmware.programmer
    end

    def clean
      @firmware.make 'clean'
    end

    def keyboards
      puts @firmware.keyboards
    end

    private
    def parser(args)
      options = {}

      OptionParser.new do |parser|
        parser.banner = USAGE

        options[:keymap] = config[:keymap]
        parser.on("-k", "--keymap KEYMAP", "Your keymap name (default: #{options[:keymap]})") do |v|
          options[:keymap] = v
        end

        parser.on("-v", "--version", "Show qmk-cli version") do
          spec = Gem::Specification::load("qmk_cli.gemspec")
          puts spec.version
        end

        options[:help] = parser
        parser.on("-h", "--help", "Show this help message") do
          puts parser
        end
      end.parse!

      options
    end

    def parse_command(cmd)
      cmd.gsub(/\-/, '_').downcase
    end

    def config
      defaults = {
        standalone_keymaps: standalone_keymaps?,
        keyboards: [],
        keymaps: [],
        keymap: `whoami`.strip
      }

      if standalone_keymaps?
        c = YAML.load_file('.qmk')
                .each_with_object({}) do |(k,v), memo|
                  memo[k.to_sym] = v
                end

        return defaults.merge c
      end

      return defaults
    end

    def standalone_keymaps?
      File.exists? '.qmk'
    end

    def method_missing(*args)
      puts @options[:help]
    end
  end
end
