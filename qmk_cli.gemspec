Gem::Specification.new do |s|
  s.name        = "qmk-cli"
  s.version     = "0.2.0"
  s.date        = "2018-02-27"
  s.summary     = "A cli wrapper for QMK Firmware"
  s.authors     = ["Nic Haynes"]
  s.email       = "nic@nicinabox.com"
  s.files       = `git ls-files -z`.split("\x0")
  s.homepage    = "https://github.com/nicinabox/qmk-cli"
  s.license     = "ISC"

  s.executables << "qmk"
end
