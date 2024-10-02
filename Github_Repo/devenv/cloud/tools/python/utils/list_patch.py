import subprocess

def print_out(product_patch_list):
    for product,patch in product_patch_list.iteritems():
        print("    {0}: {1}".format(product,patch))


def get_product_patches(env):
    product_patch_list = {}
    p = subprocess.Popen('ramp config ' + env +' && ramp ssh 1 root ramp list-updates', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    product=None
    for line in p.stdout.readlines():
        if '-c' in line:
            product = line.partition('list')[2]

        else:
            if 'Installed' not in line:
                patches = line.partition('[echo]')[2].strip()
                if len(patches):
                    product = product.strip()
                    if product in product_patch_list:
                        product_patch_list[product] += ", " +patches
                    else:
                        product_patch_list[product] = patches


    retval = p.wait()
    print_out(product_patch_list)



def get_env_list():
    env_list = []
    with open('./envs.list') as f:
        for line in f:
            env_list.append(line.strip())

    return env_list



if __name__ == "__main__":
   env_list = get_env_list() 
   for env in env_list:
       print
       print env
       get_product_patches(env)
