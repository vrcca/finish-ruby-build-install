#!/bin/bash

VERSION="$1"

if [ $# -ne 1 ]; then
    echo "Usage: $0 {ruby-version}"
    exit 1
fi

echo "Trying to finish ruby install for '$VERSION'";

INSTALL_PATH="$HOME/.asdf/installs/ruby/$VERSION"
RUBY_INSTALLER_PATH=$(find /var/folders/ -type directory -name "ruby-$VERSION" 2>&- | head -n 1)

if [ ! -d "$RUBY_INSTALLER_PATH" ]; then
    echo "Ruby installer could not be found!";
    exit 1;
fi

OPENSSL_INSTALLER_PATH=$(find $(dirname $RUBY_INSTALLER_PATH) -type directory -name "openssl*" 2>&- | head -n 1)
if [ ! -d "$OPENSSL_INSTALLER_PATH" ]; then
    echo "OpenSSL installer could not be found!";
    exit 1;
fi

echo "Creating required directories..."
mkdir -p "$INSTALL_PATH/bin" "$INSTALL_PATH/lib" "$INSTALL_PATH/include"

echo "Installing openssl..."
make --directory $OPENSSL_INSTALLER_PATH install

echo "Installing ruby..."
make --directory $RUBY_INSTALLER_PATH install

echo "Setting up certificates..."
SSL_CERTS_FILE="$INSTALL_PATH/openssl/ssl/cert.pem"
security find-certificate -a -p /Library/Keychains/System.keychain > $SSL_CERTS_FILE
security find-certificate -a -p /System/Library/Keychains/SystemRootCertificates.keychain >> $SSL_CERTS_FILE

echo "Running reshim..."
asdf reshim ruby

echo "You should be able to set the ruby version and run the healthchecks with: curl -sL https://git.io/vQhWq | ruby"

exit 0
