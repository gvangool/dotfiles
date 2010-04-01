from fabric.api import *
from fabric.contrib.files import exists, append

env.editor = 'vim'

def update():
    '''Update all'''
    _update()
    _upgrade()
    vcs_update = {'git': 'git pull', 'hg': 'hg update', 'svn': 'svn up'}
    if exists('.git'):
        run(vcs_update['git'])
    if exists('.svn'):
        run(vcs_update['svn'])
    if exists('.repos'):
        # read the file and find all the existing repositories
        get('~/.repos', '/tmp/repos')
        f = open('/tmp/repos')
        for line in f.readlines():
            line = line.strip()
            parts = line.split(' ')
            with cd(parts[1]):
                run(vcs_update[parts[0]])

def _update():
    sudo('export DEBIAN_FRONTEND=noninteractive; apt-get update -q')

def _upgrade():
    sudo('export DEBIAN_FRONTEND=noninteractive; apt-get upgrade -yq')

def _install(*args, **kwargs):
    '''Wrapper function to install something, will make it easier to port to a different platform'''
    if len(args) == 0:
        return
    else:
        package_list = args

    options = '-yq'
    if kwargs.get('allow_unauthenticated', False):
        options += ' --allow-unauthenticated'
    package_list = ' '.join(package_list)
    sudo('export DEBIAN_FRONTEND=noninteractive; apt-get install %s %s' % (options, package_list,))

def __validate_not_empty(value, key='value'):
    if value.strip() == '':
        raise Exception('Please provide a %s.' % key)
    return value

def install_default_packages():
    '''Install some default packages'''
    _install('vim', 'screen', 'lynx', 'smbfs', 'tofrodos')

def install_vcs():
    '''Install most used VCS (svn, git, hg) '''
    _install('subversion', 'git-core', 'mercurial')

def install_python():
    '''Install Python stuff'''
    _install('python', 'python-setuptools', 'python-dev', 'build-essential')
    sudo('easy_install pip')
    sudo('pip install virtualenv virtualenvwrapper')
    # extra's to build certain python packages
    # needed to build MySQL-python
    _install('libmysqlclient15-dev')
    # needed for PIL
    _install('libfreetype6-dev', 'libjpeg-dev')

def create_python_env(env_name='generic', requirements_file=None):
    '''
    Create a python virtualenv, based on the given requirements file.
    If no requirements file is given, initialize it we some convenient packages
    '''
    py_env = '~/env/%s' % env_name
    if requirements_file is None:
        run('pip install -E %s ipython suds pygments httplib2 textile markdown simplejson django' % py_env)
        run('pip install -E %s http://effbot.org/downloads/Imaging-1.1.6.tar.gz' % py_env)
        run('pip install -E %s MySQL-python' % py_env)
    else:
        run('pip install -E %s -r %s' % (py_env, requirements_file))

def install_ruby():
    _install('ruby1.8', 'libbluecloth-ruby', 'libopenssl-ruby1.8', 'ruby1.8-dev', 'ri', 'rdoc', 'irb')
    sudo('ln -s /usr/bin/ruby1.8 /usr/bin/ruby')
    # gem install
    run('mkdir -p src')
    with cd('src'):
        run('wget http://rubyforge.org/frs/download.php/69365/rubygems-1.3.6.tgz')
        run('tar xvzf rubygems-1.3.6.tgz')
        with cd('rubygems-1.3.6'):
            sudo('ruby setup.rb')
            sudo('ln -s /usr/bin/gem1.8 /usr/bin/gem')

def install_duplicity(env_name='backup'):
    '''Install the duplicity backup tool (http://duplicity.nongnu.org/)'''
    py_env = '~/env/%s' % env_name
    _install('python', 'python-setuptools', 'python-dev', 'build-essential', 'librsync-dev')
    run('pip install -E %s boto' % py_env)
    run('pip install -E %s http://code.launchpad.net/duplicity/0.6-series/0.6.05/+download/duplicity-0.6.05.tar.gz' % py_env)

def install_nginx():
    '''Install nginx as a webserver or reverse proxy'''
    version = '0.7.64'
    run('mkdir -p src')
    with cd('src'):
        run('wget http://sysoev.ru/nginx/nginx-%s.tar.gz' % version)
        run('tar xf nginx-%s.tar.gz' % version)
        # requirements for nginx
        _install('libc6', 'libpcre3', 'libpcre3-dev', 'libpcrecpp0', 'libssl0.9.8', 'libssl-dev', 'zlib1g', 'zlib1g-dev', 'lsb-base')
        with cd('nginx-%s' % version):
            run('''./configure --with-http_ssl_module \\
                   --sbin-path=/usr/local/sbin \\
                   --with-http_gzip_static_module \\
                   --with-sha1=/usr/lib''')
            run('make')
            sudo('make install')

def install_apache2(type='python'):
    '''Install Apache2 as a application backend'''
    _install('apache2')
    if type == 'python':
        _install('libapache2-mod-wsgi')
    elif type == 'php5':
        _install('libapache2-mod-php5', 'php5', 'php5-mysql', 'php5-gd')
    elif type == 'ruby':
        install_ruby()
        _install('libapache2-mod-passenger')
    # we want rid of the default apache config
    sudo('a2dissite default; /etc/init.d/apache2 restart', pty=True)

def install_mysql():
    '''Install MySQL as database'''
    install_mysql_server()
    install_mysql_client()

def install_mysql_server():
    '''Install MySQL server'''
    _install('mysql-server-5.0')

def install_mysql_client():
    '''Install MySQL client'''
    _install('mysql-client-5.0')

def install_apt_cacher(admin='root@localhost'):
    '''Install apt-cacher server'''
    _install('apt-cacher')
    sudo('echo AUTOSTART=1 >> /etc/default/apt-cacher')
    sudo('echo \'EXTRAOPT=" admin_email=%s"\' >> /etc/default/apt-cacher' % admin)
    sudo('/etc/init.d/apt-cacher restart')

def install_latex():
    '''Install LaTeX'''
    _install('texlive', 'texlive-font*', 'texlive-latex*')
    if getattr(env, 'editor', 'vim') == 'vim':
        _install('vim-latexsuite')

def install_vlc():
    '''Install VLC media player'''
    _install('vlc', 'mozilla-plugin-vlc', 'videolan-doc')

def install_cdripper():
    '''
    Install RubyRipper to convert audio cd to MP3/OGG/Flac/...

    Website: http://wiki.hydrogenaudio.org/index.php?title=Rubyripper
    '''
    version = '0.5.7'
    _install('cd-discid', 'cdparanoia', 'flac', 'lame', 'mp3gain', 'normalize-audio', 'ruby-gnome2', 'ruby', 'vorbisgain')
    run('mkdir -p src')
    with cd('src'):
        run('wget http://rubyripper.googlecode.com/files/rubyripper-%s.tar.bz2' % version)
        run('bzip2 -d rubyripper-%s.tar.bz2' % version)
        run('tar xf rubyripper-%s.tar' % version)
        with cd('rubyripper-%s' % version):
            # default options: gui + command line
            run('./configure --enable-lang-all --enable-gtk2 --enable-cli')
            sudo('make install')

def install_dvdripper():
    '''Install k9copy as DVD ripper'''
    if not exists('/etc/apt/sources.list.d/medibuntu.list'):
        sudo('wget http://www.medibuntu.org/sources.list.d/$(lsb_release -cs).list --output-document=/etc/apt/sources.list.d/medibuntu.list')
        _update()
        _install('medibuntu-keyring', allow_unauthenticated=True)
        _update()
    _install('libdvdcss2')
    _install('k9copy')

def install_wine():
    '''Install wine'''
    _install('wine')

def install_moc(add_lastfm=True):
    '''
    Install the MOC music player (http://moc.daper.net/). It will also install
    lastfmsubmitd (http://www.red-bean.com/decklin/lastfmsubmitd/) and set it
    up to submit your plays
    '''
    apps = ['moc']
    if add_lastfm:
        apps += ['lastfmsubmitd']
    _install(*apps)

    if add_lastfm:
        username = prompt('Last.fm username?', validate=lambda v: __validate_not_empty(v, key='username'))
        password = prompt('Last.fm password?', validate=lambda v: __validate_not_empty(v, key='password'))
        # create lastfm config
        append('[account]\nuser = %s\npassword = %s' % (username,password,), '/etc/lastfmsubmitd.conf', use_sudo=True)
        # add user to lastfm group so we can submit
        sudo('adduser %s lastfm' % env.user)
        # setup moc to submit to lastfm on song change (use script from
        # http://lukeplant.me.uk/blog/posts/moc-and-last-fm/ to only submit
        # when we're half way through)
        run('mkdir -p ~/.moc')
        with cd('~/.moc'):
            run('wget http://files.lukeplant.fastmail.fm/public/moc_submit_lastfm')
            run('chmod a+x moc_submit_lastfm')
            append('OnSongChange = "/home/%(user)s/.moc/moc_submit_lastfm --artist %%a --title %%t --length %%d --album %%r"' % env, 'config')

def install_extra_tops():
    _install('htop', 'iotop', 'nethogs')

def install_memcached():
    'Install memcached server'
    _install('libevent-dev')
    run('mkdir -p src')
    with cd('src'):
        run('wget http://memcached.googlecode.com/files/memcached-1.4.4.tar.gz')
        run('tar xf memcached-1.4.4.tar.gz')
        with cd('memcached-1.4.4'):
            args = ['--prefix=', '--exec-prefix=/usr', '--datarootdir=/usr']
            if getattr(env, 'is_64bit', False):
                args.append('--enable-64bit')
            run('./configure %s' % ' '.join(args))
            run('make')
            sudo('make install')
            sudo('cp scripts/memcached-init /etc/init.d/memcached')
            sudo('mkdir -p /usr/share/memcached')
            sudo('cp -R scripts /usr/share/memcached')
    install_memcached_client()

def install_memcached_client():
    'Install libmemcached as client library for memcached'
    _install('libevent-dev', 'build-essential')
    run('mkdir -p src')
    with cd('src'):
        run('wget http://download.tangent.org/libmemcached-0.38.tar.gz')
        run('tar xf libmemcached-0.38.tar.gz')
        with cd('libmemcached-0.38'):
            run('./configure')
            run('make')
            sudo('make install')

def install_memcached_client_python():
    'Install pylibmc (and thus libmemcached) as client libraries for memcached'
    install_memcached_client()
    _install('python', 'python-setuptools', 'python-dev', 'build-essential')
    run('mkdir -p src')
    with cd('src'):
        run('wget http://pypi.python.org/packages/source/p/pylibmc/pylibmc-1.0.tar.gz#md5=182d95a6d493f3cbb7bc83ae7e275816')
        run('tar xf pylibmc-1.0.tar.gz')
        with cd('pylibmc-1.0'):
            if hasattr(env, 'virtual_env'):
                run('. %(virtual_env)s/bin/activate; python setup.py install --with-libmemcached=/usr/local/lib' % env)
            else:
                sudo('python setup.py install --with-libmemcached=/usr/local/lib' % env)
        if not exists('/etc/ld.so.conf.d/local_lib'):
            append('/usr/local/lib/', '/etc/ld.so.conf.d/local_lib', use_sudo=True)
            sudo('ldconfig')

# package combinations for certain roles (webserver, database, desktop)
def setup_base():
    update()
    install_default_packages()
    install_vcs()

def setup_desktop():
    setup_base()
    install_python()
    install_vlc()
    install_duplicity()
    _install('unrar', 'nautilus-open-terminal', 'p7zip-full')

def setup_webserver(type='python'):
    setup_base()
    install_python()
    install_apache2(type)
    install_mysql_client()

def setup_database():
    update()
    install_mysql()

def setup_apt_cacher(admin='root@localhost'):
    update()
    install_apt_cacher(admin)
