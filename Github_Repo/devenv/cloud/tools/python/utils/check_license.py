#!/usr/bin/python2.7
import subprocess
from datetime import datetime
import os

def invoke(command):
    '''Invoke command as a new system process and return its output'''
    return subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

def get_product_expirationdate(env):
    '''p = subprocess.Popen('ramp config ' + env +' && ramp ssh 1 root ramp update-ramp && ramp ssh 1 root ramp aboutAssure', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)'''
    p = invoke('ramp config ' + env +' && ramp ssh 1 root ramp update-ramp && ramp ssh 1 root ramp aboutAssure')
    expirationDate=None
    for line in p.stdout.readlines():
        
        if 'Product Expiration' in line:
            expirationDate = line.split()[3].strip()
            break

    retval = p.wait()
    return expirationDate

def get_env_list():
    env_list = []
    with open('/opt/bin/envs.list') as f:
        for line in f:
            env_list.append(line.strip())

    return env_list



if __name__ == "__main__":
   env_list_cmd="ls -al /opt/cloudramp/*.json | grep -v Webserver | cut -d' ' -f10 | cut -d'/' -f4 | cut -d'.' -f1 > /opt/bin/envs.list"
   os.system(env_list_cmd)
   '''env_list = get_env_list()'''
   env_list = ['MOA_Test']
   for env in env_list:
       print
       expirationDate = get_product_expirationdate(env)
       today=datetime.now()
       end_date = datetime.strptime(expirationDate, "%m/%d/%Y")

       days = abs((today  - end_date).days)
       '''if (abs(today - end_date).days <= 31):'''
       email_body=env+"    " + expirationDate + "    " + str(days) + " days left"
       email_command = "mail -s 'Product License Expiration Notification' rli@infogix.com <<< '%s'" %(email_body)
       os.system(email_command)

            
       

