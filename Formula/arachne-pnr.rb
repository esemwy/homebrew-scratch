# Documentation: https://docs.brew.sh/Formula-Cookbook
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class ArachnePnr < Formula
  desc "Arachne-pnr implements the place and route step of the hardware compilation process for FPGAs."
  homepage "https://github.com/cseed/arachne-pnr/"
  url "https://github.com/cseed/arachne-pnr/archive/master.zip"
  version ""
  sha256 ""

  depends_on "python3"
  depends_on "pkg-config"
  depends_on "icestorm"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "arachne-pnr", "--help"
  end
end
