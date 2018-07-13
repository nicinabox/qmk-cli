require 'minitest/autorun'
require 'programmer'

class ProgrammerTest < Minitest::Test
  def setup
    @protected_methods = Programmer.private_instance_methods
    Programmer.send(:public, *@protected_methods)

    @atreus = Programmer.new 'test/fixtures/atreus'
  end

  def test_bootloader
    assert_equal @atreus.bootloader, 'caterina'
  end

  def test_flasher
    assert_equal @atreus.flasher, 'avrdude'
  end

  def test_bootloader_not_found
    prog = Programmer.new ''
    assert_nil prog.bootloader
  end

  def test_flasher_not_found
    prog = Programmer.new ''
    assert_nil prog.flasher
  end

  def test_bootloader_mapping
    prog = Programmer.new ''
    assert_equal prog.bootloader_from_size(512), 'halfkay'
    assert_equal prog.bootloader_from_size(1024), 'halfkay'
    assert_equal prog.bootloader_from_size(2048), 'usbasploader'
    assert_equal prog.bootloader_from_size(4096), 'atmel-dfu'
  end

  def test_conditional_bootloader
    planck = Programmer.new 'test/fixtures/planck'
    # assert_
  end
end
