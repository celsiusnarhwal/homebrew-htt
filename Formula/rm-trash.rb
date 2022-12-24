class RmTrash < Formula
  include Language::Python::Virtualenv

  desc "🗑 Safe(r) deletion of files from the macOS command line"
  homepage "https://github.com/celsiusnarhwal/rm-trash"
  url "https://files.pythonhosted.org/packages/66/29/0e0608f2634eeaa9f3528d2a445cc09c9fbd5727c20fdc90b4cd5e73806c/rm_trash-0.0.5.tar.gz"
  sha256 "238e1a324b21ccbd632f381134d5b5d79ee7a83376610aefd6ccba3c3ad38666"

  bottle do
    root_url "https://github.com/celsiusnarhwal/homebrew-htt/releases/download/rm-trash-0.0.5"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7034a4a4c6c144187d736f4f47b15642f70de5d8b4b7cf8b8b83d3f2ddc263f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ce5ea60a97b6a30bf7a79a45c57d6a337b32634a2ed13221f3a2bc14a6b007a"
    sha256 cellar: :any_skip_relocation, monterey:       "d7034a4a4c6c144187d736f4f47b15642f70de5d8b4b7cf8b8b83d3f2ddc263f"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ce5ea60a97b6a30bf7a79a45c57d6a337b32634a2ed13221f3a2bc14a6b007a"
  end

  depends_on "python3"

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "inflect" do
    url "https://files.pythonhosted.org/packages/dd/34/0faab1eb3b2f30f1ed074672f21d39fbfd9ee780e9f16e28ca8bfc5e646f/inflect-6.0.2.tar.gz"
    sha256 "f1a6bcb0105046f89619fde1a7d044c612c614c2d85ef182582d9dc9b86d309a"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/7d/7d/58dd62f792b002fa28cce4e83cb90f4359809e6d12db86eedf26a752895c/pydantic-1.10.2.tar.gz"
    sha256 "91b8e218852ef6007c2b98cd861601c6a09f1aa32bbbb74fab5b1c33d4a1e410"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/e0/ef/5905cd3642f2337d44143529c941cc3a02e5af16f0f65f81cbef7af452bb/Pygments-2.13.0.tar.gz"
    sha256 "56a8508ae95f98e2b9bdf93a6be5ae3f7d8af858b43e02c5a2ff083726be40c1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/11/23/814edf09ec6470d52022b9e95c23c1bef77f0bc451761e1504ebd09606d3/rich-12.6.0.tar.gz"
    sha256 "ba3a3775974105c221d31141f2c116f4fd65c5ceb0698657a11e9f295ec93fd0"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/bd/e6/fdf53ebbf08016dba98f2b047d4db95790157f0e2eed3b14bb5754271475/shellingham-1.5.0.tar.gz"
    sha256 "72fb7f5c63103ca2cb91b23dee0c71fe8ad6fbfd46418ef17dbe40db51592dad"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/e1/45/bcbc581f87c8d8f2a56b513eb994d07ea4546322818d95dc6a3caf2c928b/typer-0.7.0.tar.gz"
    sha256 "ff797846578a9f2a201b53442aedeb543319466870fbe1c701eab66dd7681165"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/e3/a7/8f4e456ef0adac43f452efc2d0e4b242ab831297f1bac60ac815d37eb9cf/typing_extensions-4.4.0.tar.gz"
    sha256 "1511434bb92bf8dd198c12b1cc812e800d4181cfcb867674e0f8279cc93087aa"
  end


  def install
    virtualenv_install_with_resources
  end

  test do
    false
  end
end