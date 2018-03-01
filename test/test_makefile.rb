require 'minitest/autorun'
require 'makefile'

class MakefileTest < Minitest::Test
  def setup
    @make = Makefile.new 'test/fixtures/atreus/rules.mk'
  end

  def test_basic_value
    value = @make.get :mcu
    assert_equal value, 'atmega32u4'
  end

  def test_complex_value
    value = @make.get :opt_defs
    assert_equal value, '-DATREUS_ASTAR -DINTERRUPT_CONTROL_ENDPOINT'
  end

  def test_logical_value
    value = @make.get :bootloader
    assert_equal value, 'caterina'
  end
end
