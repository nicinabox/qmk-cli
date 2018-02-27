Gem::Specification.new do |s|
  s.name        = 'qmk-cli'
  s.version     = '0.1.0'
  s.date        = '2018-02-27'
  s.summary     = "A cli wrapper for QMK Firmware"
  s.description = "A cli wrapper for QMK Firmware"
  s.authors     = ["Nic Haynes"]
  s.email       = 'nic@nicinabox.com'
  s.files       = ['lib/cli.rb', 'lib/firmware.rb', 'lib/programmer.rb']
  s.homepage    =
    'http://rubygems.org/gems/qmk-cli'
  s.license       = 'MIT'

  s.executables << 'qmk'
end
