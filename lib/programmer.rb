require 'makefile'

FLASHERS = {
  'dfu': ['lufa-dfu', 'qmk-dfu', 'atmel-dfu'],
  'avrdude': ['caterina', 'usbasploader'],
  'teensy': 'halfkay',
}

BOOTLOADERS = {
  'halfkay': ['512', '1024'],
  'atmel-dfu': '4096',
  'usbasploader': '2048',
}

class Programmer
  def initialize(keyboard_path)
    @keyboard_path = keyboard_path
  end

  def bootloader
    filename = "#{@keyboard_path}/rules.mk"
    parse_bootloader_name(filename) if File.exists? filename
  end

  def flasher
    bootloader and FLASHERS.each do |k, v|
      break k if v.include? bootloader.downcase
    end
  end

  private
  def bootloader_from_size(size)
    size and BOOTLOADERS.each do |k, v|
      break k.to_s if v.include? size
    end
  end

  def parse_bootloader_name(filename)
    make = Makefile.new(filename)
    name = make.value 'BOOTLOADER'
    return name if name

    size = make.value 'BOOTLOADER_SIZE'
    return bootloader_from_size(size) if size

    opt_defs = make.value 'OPT_DEFS'
    match = opt_defs.match /BOOTLOADER_SIZE=(\w+)/
    return bootloader_from_size(match[1]) if match
  end
end
