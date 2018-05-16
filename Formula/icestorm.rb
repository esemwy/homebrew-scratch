class Icestorm < Formula
  desc "Project IceStorm aims at reverse engineering and documenting the bitstream format of Lattice iCE40 FPGAs"
  homepage "http://www.clifford.at/icestorm/"
  head "https://github.com/cliffordwolf/icestorm.git"

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
