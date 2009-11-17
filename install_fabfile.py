from fabric.api import *
from fabric.contrib.files import exists

env.roledefs = {'desktop': ['192.168.1.117',],
                'server': ['127.0.0.1',],}
env.editor = 'vim'

def update():
    ''' Update all '''
    sudo('apt-get update')
    sudo('apt-get upgrade -y')
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

def _install(*args):
    ''' Wrapper function to install something, will make it easier to port to a different platform '''
    if len(args) == 0:
        return
    else:
        package_list = args

    package_list = ' '.join(package_list)
    sudo('apt-get install -y %s' % package_list)

def install_default_packages():
    ''' Install some default packages '''
    _install('vim', 'screen', 'lynx', 'smbfs', 'tofrodos')

def install_vcs():
    ''' Install most used VCS (svn, git, hg) '''
    _install('subversion', 'git-core', 'mercurial')

def install_python():
    ''' Install Python stuff '''
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

def install_duplicity(env_name='backup'):
    '''Install the duplicity backup tool (http://duplicity.nongnu.org/)'''
    py_env = '~/env/%s' % env_name
    _install('python', 'python-setuptools', 'python-dev', 'build-essential', 'librsync-dev')
    run('pip install -E %s boto' % py_env)
    run('pip install -E %s http://code.launchpad.net/duplicity/0.6-series/0.6.05/+download/duplicity-0.6.05.tar.gz' % py_env)

def install_nginx():
    ''' Install nginx as a webserver or reverse proxy '''
    version = '0.7.62'
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
    ''' Install Apache2 as a application backend '''
    _install('apache2')
    if type == 'python':
        _install('libapache2-mod-wsgi')
    elif type == 'php5':
        _install('libapache2-mod-php5', 'php5-mysql')
    # we want rid of the default apache config
    sudo('a2dissite default; /etc/init.d/apache2 restart', pty=True)

def install_mysql():
    ''' Install MySQL as database '''
    install_mysql_server()
    install_mysql_client()

def install_mysql_server():
    ''' Install MySQL server '''
    _install('mysql-server-5.0')

def install_mysql_client():
    ''' Install MySQL client '''
    _install('mysql-client-5.0')

def install_latex():
    ''' Install LaTeX '''
    _install('texlive', 'texlive-font*', 'texlive-latex*')
    if getattr(env, 'editor', 'vim') == 'vim':
        _install('vim-latexsuite')

def install_vlc():
    '''Install VLC media player'''
    _install('vlc', 'mozilla-plugin-vlc', 'videolan-doc')

# package combinations for certain roles (webserver, database, desktop)
def setup_desktop():
    update()
    install_default_packages()
    install_vcs()
    install_python()
    install_vlc()
    install_duplicity()

def setup_webserver(type='python'):
    update()
    install_default_packages()
    install_vcs()
    install_python()
    install_apache2(type)
    install_mysql_client()

def setup_database():
    update()
    install_mysql()
