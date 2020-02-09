class PrjTrellis < Formula
  desc "Arachne-pnr implements the place and route step of the hardware compilation process for FPGAs."
  homepage "https://github.com/SymbiFlow/prjtrellis"
  head "https://github.com/SymbiFlow/prjtrellis.git"
  sha256 "b9ad8a6a57d72cd9d90736b5c9bc83960d79b667ab8c14f60a704519f41d7785"

  depends_on "cmake" => :build
  depends_on "python3"
  depends_on "boost-python3"
  depends_on "pkg-config"
  depends_on "open-ocd"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", "/usr/local/lib/pkgconfig"
    Dir.chdir('libtrellis')
    system "cmake", "-DCMAKE_INSTALL_PREFIX=/usr", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  # test do
  #   system "arachne-pnr", "--help"
  # end
end