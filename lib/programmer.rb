require 'makefile'

UTILITIES = {
  'dfu': ['BOOTLOADER_DFU', 'BOOTLOADER_LUFA_DFU', 'BOOTLOADER_QMK_DFU'],
  'avrdude': ['BOOTLOADER_CATERINA'],
  'teensy': ['BOOTLOADER_HALFKAY'],
}

class Programmer
  def initialize(keyboard, keyboard_path, lib_path)
    @keyboard = keyboard
    @keyboard_path = keyboard_path
    @lib_path = lib_path
  end

  def utility
    flasher = nil

    makefile_output.each_line do |line|
      flasher = find_flashing_utility line
      break if flasher
    end

    flasher
  end

  private
  def find_flashing_utility(line)
    match = UTILITIES.find do |k, v|
      v.any? {|val| line.include? val}
    end

    match and match[0].to_s
  end

  def makefile_output
    make = Makefile.new("#{@lib_path}/Makefile")
    make.dry_run("#{@keyboard}:default:build")
  end
end
