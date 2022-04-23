#!/bin/bash

installPath=$1
gomoPath=""

if [ "$installPath" != "" ]; then
    gomoPath=$installPath
else
    gomoPath=/usr/local/bin
fi

UNAME=$(uname)
ARCH=$(uname -m)

rmOldFiles() {
    if [ -f $gomoPath/gomo ]; then
        sudo rm -rf $gomoPath/gomo*
    fi
}

v=$(curl --silent "https://get-latest.secman.dev/abdfnx/gomo")

releases_api_url=https://github.com/abdfnx/gomo/releases/download

successInstall() {
    echo "🙏 Thanks for installing Gomo! If this is your first time using the CLI, be sure to run `gomo help` first."
}

mainCheck() {
    echo "Installing gomo version $v"
    name=""

    if [ "$UNAME" == "Linux" ]; then
        if [ $ARCH = "x86_64" ]; then
            name="gomo_linux_${v}_amd64"
        elif [ $ARCH = "i686" ]; then
            name="gomo_linux_${v}_386"
        elif [ $ARCH = "i386" ]; then
            name="gomo_linux_${v}_386"
        elif [ $ARCH = "arm64" ]; then
            name="gomo_linux_${v}_arm64"
        elif [ $ARCH = "arm" ]; then
            name="gomo_linux_${v}_arm"
        fi

        gomoURL=$releases_api_url/$v/$name.zip

        wget $gomoURL
        sudo chmod 755 $name.zip
        unzip $name.zip
        rm $name.zip

        # gomo
        sudo mv $name/bin/gomo $gomoPath

        rm -rf $name

    elif [ "$UNAME" == "Darwin" ]; then
        if [ $ARCH = "x86_64" ]; then
            name="gomo_macos_${v}_amd64"
        elif [ $ARCH = "arm64" ]; then
            name="gomo_macos_${v}_arm64"
        fi

        gomoURL=$releases_api_url/$v/$name.zip

        wget $gomoURL
        sudo chmod 755 $name.zip
        unzip $name.zip
        rm $name.zip

        # gomo
        sudo mv $name/bin/gomo $gomoPath

        rm -rf $name

    elif [ "$UNAME" == "FreeBSD" ]; then
        if [ $ARCH = "x86_64" ]; then
            name="gomo_freebsd_${v}_amd64"
        elif [ $ARCH = "i386" ]; then
            name="gomo_freebsd_${v}_386"
        elif [ $ARCH = "i686" ]; then
            name="gomo_freebsd_${v}_386"
        elif [ $ARCH = "arm64" ]; then
            name="gomo_freebsd_${v}_arm64"
        elif [ $ARCH = "arm" ]; then
            name="gomo_freebsd_${v}_arm"
        fi

        gomoURL=$releases_api_url/$v/$name.zip

        wget $gomoURL
        sudo chmod 755 $name.zip
        unzip $name.zip
        rm $name.zip

        # gomo
        sudo mv $name/bin/gomo $gomoPath

        rm -rf $name
    fi

    # chmod
    sudo chmod 755 $gomoPath/gomo
}

rmOldFiles
mainCheck

if [ -x "$(command -v gomo)" ]; then
    successInstall
else
    echo "Download failed 😔"
    echo "Please try again."
fi
