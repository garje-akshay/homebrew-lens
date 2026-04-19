class LensAgent < Formula
  desc "Lens agent — run the device backend + ws-scrcpy + tunnel on your Mac"
  homepage "https://github.com/garje-akshay/lens"
  version "0.1.5"
  license "MIT"

  # android-platform-tools is a cask, not a formula, so it can't be declared
  # as depends_on here. `lens-agent doctor` checks for adb at runtime and
  # prints the cask-install hint if it's missing.
  #
  # ws-scrcpy 0.8.1 bundles node-pty 0.10.1 which fails to compile on Node 22+
  # (V8 API changes), so we pin the runtime to node@20. The agent prepends
  # /opt/homebrew/opt/node@20/bin to PATH when spawning children.
  depends_on "cloudflared"
  depends_on "node@20"

  def caveats
    <<~EOS
      lens-agent also needs `adb` from the android-platform-tools cask:
        brew install --cask android-platform-tools
      Run `lens-agent doctor` to verify all prerequisites.
    EOS
  end

  on_macos do
    on_arm do
      url "https://github.com/garje-akshay/homebrew-lens/releases/download/v#{version}/lens-agent-arm64"
      sha256 "8ec1e770572d7729da29f7c2a607b9f58cecc24df38520db9b4be7bb250ddae4"
    end
    on_intel do
      url "https://github.com/garje-akshay/homebrew-lens/releases/download/v#{version}/lens-agent-x64"
      sha256 "05c708b1256897d0517e3714e669528a92870fec861b783f223ada9051020003"
    end
  end

  def install
    bin.install Dir["*"].first => "lens-agent"
  end

  test do
    assert_match "lens-agent", shell_output("#{bin}/lens-agent --version")
    assert_match "All prerequisites installed.", shell_output("#{bin}/lens-agent doctor")
  end
end
