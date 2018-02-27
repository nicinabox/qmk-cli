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
    @bootloader ||= begin
      filename = "#{@keyboard_path}/rules.mk"
      parse_bootloader_name(filename) if File.exists? filename
    end
  end

  def flasher
    bootloader and FLASHERS.each do |k, v|
      break k if v.include? bootloader
    end
  end

  private
  def bootloader_from_size(size)
    size and BOOTLOADERS.each do |k, v|
      break k.to_s if v.include? size
    end
  end

  def parse_bootloader_name(filename)
    name_patterns = Regexp.union(FLASHERS.values.flatten.map {|b| Regexp.new "(#{b})"})
    value_patterns = Regexp.union(BOOTLOADERS.values.flatten.map {|size| Regexp.new "#{size}"})

    File.open(filename) do |file|
      file.find do |line|
        result = line.match(name_patterns)
        break result[0] if result

        result = line.match(/BOOTLOADER_SIZE=(#{value_patterns})/)
        break bootloader_from_size(result[1]) if result
      end
    end
  end
end
