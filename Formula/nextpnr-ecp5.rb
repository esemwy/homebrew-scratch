class NextpnrEcp5 < Formula
  desc "portable FPGA place-and-route tool"
  homepage "https://symbiflow.github.io/"
  head "https://github.com/SymbiFlow/nextpnr.git"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "eigen" => :build
  depends_on "python"
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "qt5"
  depends_on "project-trellis"

  def install
    mkdir "build" do
      system "cmake", "-DARCH=ecp5", "-DTRELLIS_ROOT=#{HOMEBREW_PREFIX}/share/trellis", \
         ".", *std_cmake_args, "-DBoost_NO_BOOST_CMAKE=on", "-DBUILD_TESTS=OFF", "-DBUILD_GUI=OFF"
      system "make", "install"
    end
  end

end
