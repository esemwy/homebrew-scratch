class Openfpgaloader < Formula
  desc "JTAG loader for various FPGA"
  homepage "https://github.com/trabucayre/openFPGALoader"
  head "https://github.com/trabucayre/openFPGALoader.git"

  depends_on "cmake" => :build
  depends_on "libftdi" => :build
  depends_on "libusb" => :build
  depends_on "argp-standalone" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DENABLE_UDEV=OFF", "-DBUILD_STATIC=OFF", "-DLIBARGPSTATIC=/usr/local/lib/libargp.a", *std_cmake_args
      system "make", "install"
    end
  end

end
