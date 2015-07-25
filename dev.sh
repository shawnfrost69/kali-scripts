#!/usr/bin/env bash
#
. helper.sh

install_jdk(){
    apt_add_repo ppa:webupd8team/java
    #TODO: Can we agree the license in auto mode?
    apt-get install oracle-java7-installer -y
}

install_python(){
    if ask "Install pip & python modules" Y; then
        apt-get -y install bpython python-setuptools python-twisted python-shodan  \
        python-virtualenv python-pygments python-tornado python-sqlalchemy python-lxml python-pymongo \
        python-gnuplot python-matplotlib python-pandas python-scipy
        pip install virtualenvwrapper cookiecutter
    fi

    if ask "Install Jetbrains PyCharm Community Edition?" N; then
        cd /opt
        wget http://download-cf.jetbrains.com/python/pycharm-community-4.5.3.tar.gz
        tar xzvf pycharm-community-4.5.3.tar.gz
        rm -f pycharm-community-4.5.3.tar.gz
        mv pycharm-community-4.5.3 pycharm-community
    fi
}

install_ruby(){
    if ask "Do you want to install RVM ands set ruby-1.9.3 to default?" Y; then
        curl -L https://get.rvm.io | bash -s stable
        source /usr/local/rvm/scripts/rvm
        rvm install 1.9.3 && rvm use 1.9.3 --default

        # This loads RVM into a shell session.
        #echo [[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" >> ~/.bashrc
        echo source /usr/local/rvm/scripts/rvm >> ~/.bashrc
    fi

    if ask "Do you want to install ruby and extras?" Y; then
        # This tells RubyGems to not generate documentation for every library it installs.
        echo "gem: --no-rdoc --no-ri" > ~/.gemrc

        apt-get -y install ruby-full ruby-dev libpcap-ruby libpcap-dev libsp-gxmlcpp-dev libsp-gxmlcpp1 libxslt1.1 libxslt1-dev libxrandr-dev libfox-1.6-dev
        update-alternatives --config ruby

        gem install bundler risu ffi multi_json childprocess selenium-webdriver mechanize fxruby net-http-digest_auth pcaprub \
        net-http-persistent nokogiri domain_name unf webrobots ntlm-http net-http-pipeline nfqueue pry colorize mechanize
    fi
}

install_devel(){
    print_status "Installing development tools and environment"
    apt-get install -y build-essential module-assistant libncurses5-dev zlib1g-dev gawk flex gettext \
    gcc gcc-multilib dkms make linux-headers-$(uname -r) autoconf automake libssl-dev \
    kernel-package ncurses-dev fakeroot bzip2 linux-source openssl libreadline6 libreadline6-dev git-core zlib1g zlib1g-dev libssl-dev \
    libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison \
    libmysqlclient-dev libmagickcore-dev libmagick++-dev libmagickwand-dev libnetfilter-queue-dev git subversion mercurial
    check_success
    print_status "System Pre-requirements"

    if ask "Install i386 support? Install to compile old software!" Y; then
        dpkg --add-architecture i386
        apt-get update -y && apt-get install ia32-libs -y
    fi

    if ask "Install JDK?" Y; then
        install_jdk
    fi

    if ask "Install Python tools?" Y; then
        install_python
    fi

    if ask "Install RVM+Ruby?" Y; then
        install_ruby
    fi

    if ask "Install Sublime?" N; then
        apt_add_repo ppa:webupd8team/sublime-text-3
        apt-get install sublime-text-installer
    fi

    if ask "Install MinGW compiler+tools?" N; then
        apt-get install -y binutils-mingw-w64 gcc-mingw-w64 mingw-w64 mingw-w64-dev
    fi
}

install_devel