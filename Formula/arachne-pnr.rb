# Documentation: https://docs.brew.sh/Formula-Cookbook
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class ArachnePnr < Formula
  desc "Arachne-pnr implements the place and route step of the hardware compilation process for FPGAs."
  homepage "https://github.com/cseed/arachne-pnr/"
  head "https://github.com/cseed/arachne-pnr"

  depends_on "python3"
  depends_on "pkg-config"
  depends_on "icestorm"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", "/usr/local/lib/pkgconfig"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "arachne-pnr", "--help"
  end
end
