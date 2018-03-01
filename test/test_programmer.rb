require 'minitest/autorun'
require 'programmer'

class ProgrammerTest < Minitest::Test
  def setup
    @programmer = Programmer.new 'test'
  end

  def test_bootloader
    assert_equal @programmer.bootloader, 'caterina'
  end

  def test_flasher
    assert_equal @programmer.flasher, 'avrdude'
  end
end
