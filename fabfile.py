#A Collection of commonly used fabric scripts.

import re
from fabric.api import env, local, settings
from fabric.context_managers import hide
from fabric.operations import put, get
import cuisine
from cuisine import run, sudo
from fabric.api import parallel
from random import choice
import string
import socket
import paramiko

# FIXME: select package after detecting appropriate system
cuisine.select_package('apt')

USER_NAME = 'dhilipsiva'


def hello_world():
    run('echo "hello world"')


def vagrant():
    host = '127.0.0.1'
    port = '2222'
    for line in local('vagrant ssh-config', capture=True).split('\n'):
        match = re.search(r'Hostname\s+(\S+)', line)
        if match:
            host = match.group(1)
            continue

        match = re.search(r'User\s+(\S+)', line)
        if match:
            env.user = match.group(1)
            continue

        match = re.search(r'Port\s+(\S+)', line)
        if match:
            port = match.group(1)
            continue

        match = re.search(r'IdentityFile\s(.+)', line)
        if match:
            env.key_filename = match.group(1)
            continue

    env.hosts = ['{0}:{1}'.format(host, port)]


def _prepare():
    sudo('export DEBCONF_TERSE=yes'
        ' DEBIAN_PRIORITY=critical'
        ' DEBIAN_FRONTEND=noninteractive')


def apt(pkg):
    _prepare()
    sudo("apt-get -qqyu install %s" % pkg)


def sync_time():
    with settings(warn_only=True):
        sudo("/etc/init.d/ntp stop")
        sudo("ntpdate pool.ntp.org")
        sudo("/etc/init.d/ntp start")


def setup_time_calibration():
    sudo('apt-get -y install ntp')
    put('config/ntpdate.cron', '%s/' % env.NEWSBLUR_PATH)
    sudo('chmod 755 %s/ntpdate.cron' % env.NEWSBLUR_PATH)
    sudo('mv %s/ntpdate.cron /etc/cron.hourly/ntpdate' % env.NEWSBLUR_PATH)
    with settings(warn_only=True):
        sudo('/etc/cron.hourly/ntpdate')


def add_machine_to_ssh():
    put("~/.ssh/id_dsa.pub", "local_keys")
    run("echo `cat local_keys` >> .ssh/authorized_keys")
    run("rm local_keys")


def setup_supervisor():
    sudo('apt-get -y install supervisor')


def setup_sudoers():
    sudo('su - root -c "echo \\\\"%s ALL=(ALL) NOPASSWD: ALL\\\\" >>'
            ' /etc/sudoers"' % env.user)


@parallel
def install(package):
    """Install a package"""
    with settings(linewise=True, warn_only=True):
        sudo("apt-get update")
        for retry in range(2):
            if sudo("apt-get -y install %s" % package).failed:
                local("echo INSTALLATION FAILED FOR %s: was installing %s"
                        " $(date) >> ~/fail.log" % (env.host, package))
            else:
                break


@parallel
def install_auto(package):
    """Install a package answering yes to all questions"""
    with settings(linewise=True, warn_only=True):
        sudo("apt-get update")
        sudo('DEBIAN_FRONTEND=noninteractive /usr/bin/apt-get install -o'
            ' Dpkg::Options::="--force-confold" --force-yes -y %s'
            % package)


def install_apache():
    """Install Apache server with userdir enabled"""
    with settings(linewise=True, warn_only=True):
        sudo("apt-get update")
        sudo("apt-get -y install apache2")
        if run("ls /etc/apache2/mods-enabled/userdir.conf").failed:
            sudo("a2enmod userdir")
            sudo("/etc/init.d/apache2 restart")


@parallel
def uninstall(package):
    """Uninstall a package"""
    with settings(linewise=True, warn_only=True):
        sudo("apt-get -y remove %s" % package)


@parallel
def update():
    """Update package list"""
    with settings(linewise=True, warn_only=True):
        sudo('apt-get -yqq update')


@parallel
def upgrade():
    """Upgrade packages"""
    with settings(linewise=True, warn_only=True):
        update()
        sudo('aptitude -yvq safe-upgrade')


@parallel
def upgrade_auto():
    """Update apt-get and Upgrade apt-get answering yes to all questions"""
    with settings(linewise=True, warn_only=True):
        sudo("apt-get update")
        sudo('apt-get upgrade -o Dpkg::Options::="--force-confold"'
                ' --force-yes -y')


@parallel
def user_add(new_user, passwd=False):
    """Add new user"""
    with settings(hide('running', 'stdout', 'stderr'), warn_only=True):
        if not passwd:
            passwd = generate_passwd()
        if not sudo("echo -e '%s\n%s\n' | adduser %s" % (passwd, passwd,
                new_user)).failed:
            if env.host == 'host1.local':
                sudo("mkdir /home/%s/public_html" % new_user)
                sudo("chown %s:%s /home/%s/public_html/" % new_user)


@parallel
def user_passwd(user, passwd=False):
    """Change password for user"""
    with settings(hide('running', 'stdout', 'stderr'), warn_only=True):
        if not passwd:
            passwd = generate_passwd()
        sudo("echo -e '%s\n%s' | passwd %s" % (
        passwd, passwd, user))


@parallel
def user_delete(user):
    """Delete user"""
    with settings(linewise=True, warn_only=True):
        sudo("deluser %s" % user)


def status():
    """Display host status"""
    with settings(linewise=True, warn_only=True):
        run("uptime")
        run("uname -a")


@parallel
def shut_down():
    """Shut down a host"""
    sudo("shutdown -P 0")


@parallel
def reboot():
    """Reboot a host"""
    sudo("shutdown -r 0")


def file_put(localpath, remotepath):
    """Put file from local path to remote path"""
    with settings(linewise=True, warn_only=True):
        put(localpath, remotepath)


def file_get(remotepath, localpath):
    """Get file from remote path to local path"""
    with settings(linewise=True, warn_only=True):
        get(remotepath, localpath + '.' + env.host)


def file_remove(remotepath):
    """Remove file at remote path"""
    with settings(linewise=True, warn_only=True):
        sudo("rm -r %s" % remotepath)


def generate_passwd(length=10):
    return ''.join(choice(string.ascii_letters +
        string.digits) for _ in range(length))


def ssh_disable_passwd():
    """Disable SSH password authentication"""
    with settings(hide('running', 'user'), warn_only=True):
        sudo('echo PasswordAuthentication no >> /etc/ssh/sshd_config')
        sudo('service ssh restart')


#copy archived git repo
def copy_source():
    local('git archive $(git symbolic-ref HEAD 2>/dev/null) '
            '| bzip2 > /tmp/app_name.tar.bz2')
    remote_filename = '/tmp/app_name.tar.bz2'
    code_dir = '~/app_name'
    sudo('rm -rf %s' % code_dir)
    if cuisine.file_exists(remote_filename):
        sudo('rm %s' % remote_filename)
    cuisine.file_upload(remote_filename, '/tmp/app_name.tar.bz2')
    with cuisine.mode_sudo():
        run('mkdir -p %s' % code_dir)
        cuisine.file_attribs(remote_filename)
        run('tar jxf %s -C %s' % (remote_filename, code_dir))
        run('rm %s' % (remote_filename,))


def target():
    host = 'A Target IP or name'
    port = 22
    env.hosts = ['{0}:{1}'.format(host, port)]
    env.user = 'ubuntu'
    env.key_filename = 'key file name'


def create_user():
    cuisine.user_ensure(USER_NAME,
            home='/home/%s' % USER_NAME, shell='/bin/bash')
    cuisine.group_user_ensure('www-data', USER_NAME)


def create_virtualenv():
    if not cuisine.dir_exists('/home/%s/ENV' % USER_NAME):
        sudo('virtualenv -q --distribute '
                '/home/%s/ENV' % (
                USER_NAME), user=USER_NAME)


def run_in_virtualenv(cmd):
    with run('. /home/%s/ENV/bin/activate' % USER_NAME):
        run(cmd)


def is_host_up(host, counter=0):
    print('%d : Attempting connection to host: %s' %
            (counter, host))
    original_timeout = socket.getdefaulttimeout()
    socket.setdefaulttimeout(1)
    host_up = True
    try:
        paramiko.Transport((host, 22))
    except Exception, e:
        host_up = False
        print('%s down, %s' % (host, e))
    finally:
        socket.setdefaulttimeout(original_timeout)
        return host_up


def try_to_connect():
    counter = 0
    while not is_host_up(env.host, counter):
        counter += 1

def ssh():
    try:
        if env.host == AWS_HOST:
            local('ssh -i rewire.pem ubuntu@' + AWS_HOST)
    except:
        pass
