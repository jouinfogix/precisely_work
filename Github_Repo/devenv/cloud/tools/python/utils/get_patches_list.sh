ls -al /opt/cloudramp/*.json | grep -v Webserver | cut -d' ' -f10 | cut -d'/' -f4 | cut -d'.' -f1 > envs.list 

python list_patch.py  | tee patches.list
mail  -s "Infogix Cloud Environment Patch status" rli@infogix.com bprocek@infogix.com < patches.list 
# rm ./envs.list
