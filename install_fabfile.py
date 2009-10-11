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
                run(vcs_update[parts[0]]

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
    if getattr(env, 'editor', 'vim') == 'vim':
        _install('vim-python')
    sudo('easy_install pip')
    sudo('pip install virtualenv virtualenvwrapper')
    # extra's to build certain python packages
    # needed to build MySQL-python
    _install('libmysqlclient15-dev')
    # needed for PIL
    _install('libfreetype6-dev', 'libjpeg-dev')

#@depends('install_python')
def create_generic_python_env(env_name='generic'):
    ''' Create a simple virtualenv with some usefull tools in '''
    py_env = '~/env/%s' % env_name
    run('pip install -E %s ipython suds pygments httplib2 textile markdown simplejson django' % py_env)
    run('pip install -E %s http://effbot.org/downloads/Imaging-1.1.6.tar.gz' % py_env)
    run('pip install -E %s MySQL-python' % py_env)

def install_nginx():
    ''' Install nginx as a webserver or reverse proxy '''
    version = '0.7.61'
    run('wget http://sysoev.ru/nginx/nginx-%s.tar.gz' % version)
    run('tar xf nginx-0.7.61.tar.gz')
    # requirements for nginx
    _install('libc6', 'libpcre3', 'libpcre3-dev', 'libpcrecpp0', 'libssl0.9.8', 'libssl-dev', 'zlib1g', 'zlib1g-dev', 'lsb-base')
    with cd('nginx-%s' % version):
        run('''./configure --with-http_ssl_module \\
               --sbin-path=/usr/local/sbin \\
               --with-http_gzip_static_module \\
               --with-sha1=/usr/lib''')
        run('make')
        sudo('make install')

def install_apache2():
    ''' Install Apache2 as a application backend '''
    _install('apache2', 'libapache2-mod-wsgi')
    # we want rid of the defult apache config
    sudo('cd /etc/apache2/sites-available/; a2dissite default;', pty=True)
    #restart_webserver()

def install_latex():
    ''' Install LaTeX '''
    _install('texlive', 'texlive-font*', 'texlive-latex*')
    if getattr(env, 'editor', 'vim') == 'vim':
        _install('vim-latexsuite')

