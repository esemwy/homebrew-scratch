class ArachnePnr < Formula
  desc "Arachne-pnr implements the place and route step of the hardware compilation process for FPGAs."
  homepage "https://github.com/cseed/arachne-pnr/"
  head "https://github.com/cseed/arachne-pnr.git"
  sha256 "b9ad8a6a57d72cd9d90736b5c9bc83960d79b667ab8c14f60a704519f41d7785"

  depends_on "python3"
  depends_on "pkg-config"
  depends_on "icestorm"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", "/usr/local/lib/pkgconfig"
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "arachne-pnr", "--help"
  end
end
