class Icestorm < Formula
  desc "Project IceStorm aims at reverse engineering and documenting the bitstream format of Lattice iCE40 FPGAs"
  homepage "http://www.clifford.at/icestorm/"
  head "https://github.com/cliffordwolf/icestorm.git"
  url "https://github.com/cliffordwolf/icestorm/archive/816c47ce83e330d0b293cd5e0a2e82885fb9f74e.zip"
  sha256 "05db23066a96b233b20ec9c0919066e8accb4ca3dea7367d301b9c403a46bf3e"

  depends_on "python3"
  depends_on "pkg-config"
  depends_on "libffi"
  depends_on "libusb"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", "/usr/local/lib/pkgconfig"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "icesprog", "--help"
  end
end
