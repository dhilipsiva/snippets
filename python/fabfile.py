'''
WARNING : UNTESTED Scripts
This is just a collection from the internet. not tested yet.
'''

#A Collection of commonly used fabric scripts.

import re
import os
from fabric.api import task, env, local, sudo, settings
from fabric.context_managers import cd, hide
from fabric.operations import put, prompt
import fabric.contrib
import cuisine
from cuisine import run
cuisine.select_package('apt')
from fabric.api import cd, env, local, parallel, serial
from fabric.api import put, run, settings, sudo
import socket
import paramiko
from random import choice
import string


#vagrant
@task
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

@task	
def update():
    "Updates Debian/Ubuntu's package list"
    sudo('apt-get -yqq update')
  
@task
def upgrade():
    "Perform a safe upgrade"
    update()
    sudo('aptitude -yvq safe-upgrade')
  
def _prepare():
    sudo("export DEBCONF_TERSE=yes DEBIAN_PRIORITY=critical DEBIAN_FRONTEND=noninteractive")

@task
def apt(pkg):
    _prepare()
    sudo("apt-get -qqyu install %s" % pkg)

@task
def is_host_up(host):
    """Verify the host computer is online before action"""
    print('Attempting connection to host: %s' % host)
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
    sudo('su - root -c "echo \\\\"%s ALL=(ALL) NOPASSWD: ALL\\\\" >> /etc/sudoers"' % env.user)

@task
@parallel
def install(package):
    """Install a package"""
    with settings(linewise=True, warn_only=True):
        if is_host_up(env.host):
            sudo("apt-get update")
            for retry in range(2):
                if sudo("apt-get -y install %s" % package).failed:
                    local("echo INSTALLATION FAILED FOR %s: was installing %s $(date) >> ~/fail.log" % (env.host,package))
                else:
                    break

@task
@parallel
def install_auto(package):
    """Install a package answering yes to all questions"""
    with settings(linewise=True, warn_only=True):
        if is_host_up(env.host):
            sudo("apt-get update")
            sudo('DEBIAN_FRONTEND=noninteractive /usr/bin/apt-get install -o Dpkg::Options::="--force-confold" --force-yes -y %s' % package)

@task
@hosts('host1.local')
def install_apache():
    """Install Apache server with userdir enabled"""
    with settings(linewise=True, warn_only=True):
    	if is_host_up(env.host):
            sudo("apt-get update")
            sudo("apt-get -y install apache2")
            if run("ls /etc/apache2/mods-enabled/userdir.conf").failed:
            	sudo("a2enmod userdir")
            	sudo("/etc/init.d/apache2 restart")

@task
@parallel
def uninstall(package):
    """Uninstall a package"""
    with settings(linewise=True, warn_only=True):
        if is_host_up(env.host):
            sudo("apt-get -y remove %s" % package)

@task
@parallel
def update():
    """Update package list"""
    with settings(linewise=True, warn_only=True):
        if is_host_up(env.host):
            sudo("apt-get update")

@task
@parallel
def upgrade():
    """Upgrade packages"""
    with settings(linewise=True, warn_only=True):
        if is_host_up(env.host):
            sudo("apt-get update")
            sudo("apt-get -y upgrade")

@task 
@parallel
def upgrade_auto():
    """Update apt-get and Upgrade apt-get answering yes to all questions"""
    with settings(linewise=True, warn_only=True):
        if is_host_up(env.host):
            sudo("apt-get update")
            sudo('apt-get upgrade -o Dpkg::Options::="--force-confold" --force-yes -y')

@task
@parallel
def user_add(new_user, passwd=False):
    """Add new user"""
    with settings(hide('running', 'stdout', 'stderr'), warn_only=True):
        if is_host_up(env.host):
	    if not passwd:
                passwd = generate_passwd()
            if not sudo("echo -e '%s\n%s\n' | adduser %s" % (passwd,passwd,new_user)).failed:
                if env.host=='host1.local': 
                    sudo("mkdir /home/%s/public_html" % new_user)
                    sudo("chown %s:%s /home/%s/public_html/" % new_user)

@task
@parallel
def user_passwd(user, passwd=False):
    """Change password for user"""
    with settings(hide('running', 'stdout', 'stderr'), warn_only=True):
        if is_host_up(env.host):
            if not passwd:
                passwd = generate_passwd()
            sudo("echo -e '%s\n%s' | passwd %s" % (passwd,passwd,user))

@task
@parallel
def user_delete(user):
    """Delete user"""
    with settings(linewise=True, warn_only=True):
        if is_host_up(env.host):
            sudo("deluser %s" % user)

@task
def status():
    """Display host status"""
    with settings(linewise=True,warn_only=True):
    	if is_host_up(env.host):
     	    run("uptime")
            run("uname -a")

@task
@parallel
def shut_down():
    """Shut down a host"""
    if is_host_up(env.host):
        sudo("shutdown -P 0")

@task
@parallel
def reboot():
    """Reboot a host"""
    if is_host_up(env.host):
        sudo("shutdown -r 0")

@task
def file_put(localpath, remotepath):
    """Put file from local path to remote path"""
    with settings(linewise=True, warn_only=True):
        if is_host_up(env.host):
            put(localpath,remotepath)

@task
def file_get(remotepath, localpath):
    """Get file from remote path to local path"""
    with settings(linewise=True, warn_only=True):
        if is_host_up(env.host):
            get(remotepath,localpath+'.'+env.host)

@task
def file_remove(remotepath):
    """Remove file at remote path"""
    with settings(linewise=True, warn_only=True):
        if is_host_up(env.host):
            sudo("rm -r %s" % remotepath)

def generate_passwd(length = 10):
    return ''.join(choice(string.ascii_letters + string.digits) for _ in range(length))


@task
def ssh_disable_passwd():
	"""Disable SSH password authentication"""
	with settings(hide('running', 'user'), warn_only=True):
	        if is_host_up(env.host):
			sudo('echo PasswordAuthentication no >> /etc/ssh/sshd_config')
			sudo('service ssh restart')