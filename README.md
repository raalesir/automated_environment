Combient Challenge Task
========================

The task was to create and deploy a Virtual Environment where instructions from
the Notebook could be executed.

The setup should be as automatic as possible.

The solution  to  the task could be split in two parts:

1. create a minimal environment to be able to copy-paste commands from the
Notebook into the command prompt and execute the code line  by line locally on
the machine (local host or EC2 node) where the code will be running
2. add IPython (Jupyter) notebook in order to be able to steer calculations on 
EC2 node remotely.


Such a separation makes sence since the first point is also provides a user with
still operable infrastructure in the case more complicated setup is too demanding.

It was possible to establish the infrastrucure to execute the whole notebook
provided, except the following:

```python
print "Number of columns with corr > 0.14: %d" %varnames_extreme_corr.size
print "Number of columns with corr > 0.05: %d" %varnames_strong_corr.size
print "Number of columns with corr > 0.02: %s" %varnames_medium_corr.size

AttributeError: 'DataFrame' object has no attribute 'size'
```
That, however, does not influence on the results. For the reason see 
[here](https://github.com/pandas-dev/pandas/issues/8846).


It was chosen to use Puppet as the solution to provision OS with the packages
needed. 
The task was solved in two appoaches:
- for running calculations on the local machine with additional packages
  VirtualBox and Vagrant
- for utilizing the Cloud resources

In the case of greater time slot for the task, I could imagine to write Puppet
code more carefully, making it more versatile, including different Linux
distributions. Currently it works on Ubuntu/Trusty64.




Information for Data Engineers:
===============================  


The Virtual Machine (VM) provisioning can be done in several ways. 
The Puppet scripts provided will work with the two following scenarios.

Scenario I. Local workstation as a host machine and VM is a guest.
------------------------------------------------------------------
1. One could use a local workstation with  VirtualBox and Vagrant installed.
(Vagrant *must* be from vagran t[site](https://www.vagrantup.com/downloads.html), 
not from the linux distribution repo!)
Then in order to launch the VM the following code should be executed:

  a. `vagrant init ubuntu/trusty64`
      This will download the Vagrant box, so you can 

  b. `vagrant up` and  `vagrant ssh`
After checking that you can login,  logout from the VM and execute:

2. `git clone git@github.com:combient/Challenge_Alexey_S.git`
That will clone the repo to the specified directory. The repo contains:
    ```bash
    alexey@alexey-iMac:~/Projects/combient$ tree -L 3 manifests/ modules/
    ├── manifests
    │   └── site.pp
    ├── modules
    │   └── dependencies
    │       └── manifests
    ├── README.md
    └── Vagrantfile
    ```
3. The `Vagrantfile` from the repo should contain the following entries:
  
  ```puppet
  Vagrant.configure(2) do |config|
    config.vm.box = "ubuntu/trusty64"
    config.vm.provider "virtualbox" do |vb|
      vb.memory = "4096" # the more the better...
    end
   config.vm.provision "shell",
      inline: "sudo apt-get install -y puppet-common", 
   config.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "manifests"
      puppet.module_path = "modules"
      puppet.manifest_file = "site.pp"
     end
  end
  ```
  If the file produced by `vagrant init` will not be overwritten, do it manually.

4. `vagrant up --provision`
  That will provision the VM and install all dependencies according to the
  instructions.
5. ....

I have used this approach until I reached line 4 or 5 in the Notebook. After
that memory demands started to be too severe for my workstation. Use this
approach only if you have 8-16 GB RAM.
Otherwise switch to the Scenario II.


Scenario II. Using cloud resourses, like EC2.
----------------------------------------------

Here you will use  already existing VM at EC2.
The EC2 use XEN as a virtualizer, so VirtualBox will not work there. It means it
will not work to substitute the local workstation from the Scenario I with the 
EC2 node.

Luckily, we still can go with the repo you just cloned.

1. `ssh -X -i ACE_Challenge.pem ubuntu@ec2-52-212-62-56.eu-west-1.compute.amazonaws.com`  
After logging in to `/home/ubuntu`  type:
2. `git clone git@github.com:combient/Challenge_Alexey_S.git`
3. `sudo apt-get install  -y puppet-common`
4. From the same directory:
`sudo puppet apply --modulepath=/home/ubuntu/modules manifests/site.pp`  
This will tell Puppet to  apply the rules from its scripts onto the *current* machine, 
i.e. onto the EC2 node. 
#5. Copy the source files to the `$HOME`:  
#`scp  test.csv.gz train.csv.gz -i ACE_Challenge.pem
#ubuntu@ec2-52-212-62-56.eu-west-1.compute.amazonaws.com:/home/ubuntu`
6. Make a desision about a firewall. Either turn it off, or open ports at least 8888. 

After the installation will finish up (hopefully successfully), one could start
to play with the `pyspark`.

`ubuntu@ip-172-31-20-22:~$ pyspark`

At this stage, one could feed  the input lines from the Notebook, like 
```
>>>import sframe
>>>sf_train = sframe.SFrame.read_csv('/home/ubuntu/train.csv.gz',nrows_to_infer=80000)
```
and so on... 

The `-X` flag with `ssh` will allow to display pictures on the local machine
from which you `ssh`'d to EC2.

It is more convenient, however, to utilize `Jupyter` notebook. If the `jupyter`
installation went well, we can try launch the notebook from the *same*
directory, where the task notebook () is located:

5. `ubuntu@ip-172-31-20-22:~$ jupyter notebook`  
That should bring you to some ASCII GUI.
3. make sure that the port 8887 is not listening i.e.: `$ lsof -i :8887`. Otherwise
   change it to someting above 1024 and test again.
6. If everything went well, the `Jupyter` server is running, and we would like to
   try to connect to it from the local machine. In order to do that one should
    use  *local port forwarding*. The `Jupyter` by default will run at `http://localhost:8888/` 
   (inside the EC2 node), so we could use  8887 on our local machine.
  
  `ssh -i /home/alexey/Downloads/ACE_Challenge.pem -N -f -L localhost:8887:localhost:8888
   ubuntu@ec2-52-212-62-56.eu-west-1.compute.amazonaws.com`

7. Now we can open the brower on the localhost and enter: `localhost:8887`. That
   should bring us to the `http://localhost:8887/tree#notebooks`.

8. Upload a notebook is nesessary or create one if needed. Try to upload/delete
   files with the GUI etc.


Information for Data Scientists:
===============================

Please estimate the memory consumption for the tasks, and provide that to
the date engineers, so they know what resources to allocate.
It would also be great if you would tell what packages will be needed *with* the
versions, especially installed by `pip`. It could be a source of troubles, due to 
the potential differences in the systax between different versions and due to
interpackage dependencies to be satisfied.


As soon as the infrastructure is ready, you should do the following:

1. Ask how to access the machine with the installed infrastructure i.e.
   something like:  
 `ssh -X -i ACE_Challenge.pem
ubuntu@ec2-52-212-62-56.eu-west-1.compute.amazonaws.com`
2. After login start the `Jupyter`:  
`ubuntu@ip-172-31-20-22:~$ jupyter notebook`  
That should bring you to some ASCII GUI. Just look at it.
3. From the another terminal tab on the local machine execute: 
`ssh -i ACE_Challenge.pem -N -f -L localhost:8887:localhost:8888
ubuntu@ec2-52-212-62-56.eu-west-1.compute.amazonaws.com`
4. Start up your local Web Browser and point it to:  
`http://localhost:8887/tree#notebooks`
5. The notebook has an intuitive GUI on how to create/modify files and
   notebooks. 
6. One can upload source files, like `test.csv.gz` and `train.csv.gz` from the
   local machine to the EC2 node directly from the `Jupyter` Web-interface
 
