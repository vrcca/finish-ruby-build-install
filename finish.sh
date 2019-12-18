#!/bin/sh

VERSION="$1"

if [ $# -ne 1 ]; then
    echo "Usage: $0 {ruby-version}"
    exit 1
fi


RUBY_VERSION="ruby-$VERSION"
RUBY_INSTALLER_DIR=$(find /var/folders/ -type directory -name $RUBY_VERSION 2>&- | head -n 1)
ASDF_RUBY_INSTALL_DIR="$HOME/.asdf/installs/ruby/$VERSION"
if [ ! -d "$RUBY_INSTALLER_DIR" ]; then
    echo "Install dir could not be found!";
    exit 1;
fi

OPENSSL_INSTALL_DIR=$(find $(dirname $RUBY_INSTALLER_DIR) -type directory -name "openssl*" 2>&- | head -n 1)

mkdir -p "$ASDF_RUBY_INSTALL_DIR/bin" "$ASDF_RUBY_INSTALL_DIR/lib" "$ASDF_RUBY_INSTALL_DIR/include"

echo "Installing openssl..."
make --directory $OPENSSL_INSTALL_DIR install

echo "Installing ruby..."
make --directory $RUBY_INSTALLER_DIR install

echo "Setting up certificates..."
SSL_CERTS_FILE="$ASDF_RUBY_INSTALL_DIR/openssl/ssl/cert.pem"
security find-certificate -a -p /Library/Keychains/System.keychain > $SSL_CERTS_FILE
security find-certificate -a -p /System/Library/Keychains/SystemRootCertificates.keychain >> $SSL_CERTS_FILE

echo "Running reshim..."
asdf reshim ruby

echo "You should be able to set the ruby version and run the healthchecks with: curl -sL https://git.io/vQhWq | ruby"

exit 0
