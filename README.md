# finish-ruby-build-install
Small hack to help finish ruby build install with ASDF.

See this comment for more context: https://github.com/rbenv/ruby-build/issues/992#issuecomment-556120333

## Usage
1. Try to install a version and let it fail: `asdf install ruby 2.6.5`
2. Run the `finish.sh` script in terminal: `curl -sL https://git.io/Je5tL | bash -s "2.6.5"`
