Combient Challenge Task
========================

The task was to create and deploy a Virtual Environment where instructions from
the Notebook could be executed.

The setup should be as automatic as possible.

It was decided to split the task in two parts:

  1. create the minimal environment to be able to copy-paste commands from the
  Notebook into the command prompt and execute the code line  by line locally
  2. add IPython (Jupyter) notebook in order to be able to use EC2 node remotely
  and use interactive sessions over HTTP.


Such a separation makes sence since the first point is also provides a user with
still operable infrastructure in the case more complicated setup is too demanding.


Information for Data Engineers:
==============================  


The Virtual Machine (VM) provision can be done in several ways. 
The Puppet scripts will work with the two following scenarios.

Scenario I. Local workstation as a host machine and VM is a guest.
------------------------------------------------------------------
1. One could use a local workstation with  VirtualBox and Vagrant installed.
Then in order to launch the VM the following code should be executed.
Execute: `vagrant init ubuntu/trusty64`
This will download the Vagrant box, so you can `vagrant up` and  `vagrant ssh`

2. `git clone git@bitbucket.org:raalesir/combient_task.git`
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

Here you will use a already existing VM.
The EC2 use XEN as a virtualizer, so VirtualBox will not work there. It means it
will not work to substitute the local workstation from the Scenario I with the 
EC2 node.

Luckily, we still can go with the repo you cloned.

1. `ssh -X -i ACE_Challenge.pem ubuntu@ec2-52-212-62-56.eu-west-1.compute.amazonaws.com`

2. `git clone git@bitbucket.org:raalesir/combient_task.git`
3. `sudo apt-get install  -y puppet-common`
4. from the same directory:
`sudo puppet apply --modulepath=/home/ubuntu/modules manifests/site.pp`
This will tell Puppet to  apply the rules from its scripts onto the *current* machine, 
i.e. onto the EC2 node. 

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

The goal, however, is to utilize `Jupyter` notebook. If the `jupyter`
installation went well, we can try launch the notebook from the *same*
directory, where the notebook is located:

5. `ubuntu@ip-172-31-20-22:~$ jupyter notebook`

    That should bring you to some ASCII GUI.

6. If everything went well, the `Jupyter` server is running, and we would like to
   try to connect to it from the local machine. In order to do that one should
    use  *local posr forwarding*. The `Jupyter` will run at `http://localhost:8888/` 
   (inside the EC2 node), so we could use  8887 on our local machine.
  
  `ssh -i /home/alexey/Downloads/ACE_Challenge.pem -N -f -L localhost:8887:localhost:8888
   ubuntu@ec2-52-212-62-56.eu-west-1.compute.amazonaws.com`

7. Now we can open the brower on the localhost and enter: `localhost:8887`. That
   should bring us to the `http://localhost:8887/tree#notebooks`.

8. Upload a notebook is nesessary or create one if needed.


