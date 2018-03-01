require 'minitest/autorun'
require 'makefile'

class MakefileTest < Minitest::Test
  def setup
    @make = Makefile.new 'test/rules.mk'
  end

  def test_basic_value
    value = @make.value 'MCU'
    assert_equal value, 'atmega32u4'
  end

  def test_complex_value
    value = @make.value 'OPT_DEFS'
    assert_equal value, '-DATREUS_ASTAR -DINTERRUPT_CONTROL_ENDPOINT'
  end

  def test_logical_value
    value = @make.value 'BOOTLOADER'
    assert_equal value, 'caterina'
  end
end
