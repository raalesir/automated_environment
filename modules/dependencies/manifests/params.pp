class dependencies::params{
 
  $spark = "http://d3kbcqa49mib13.cloudfront.net/spark-1.6.1-bin-hadoop2.6.tgz"
  
  $pip_dependencies  = [
      "SFrame==2.1",
      "seaborn==0.7.1",
      "findspark==1.1.0",
      "py4j==0.10.4",
      "ipython==5.1.0",
      "sklearn==0.0",
      "jupyter==1.0.0",
#      "Cython==0.25",
 #     "pandas==0.19.0",
       "MarkupSafe==0.23",
#       "pyzmq==16.0.0",
  ]
  
  # list of matplotib dependencies. Most of them are satisfied via other packages
  $matplotlib_dependencies =[
      #"distribute==0.6.49",
      #"numpy==1.8.1",
      #"python-dateutil==2.2",
      #"tornado==3.2.2",
      #"pyparsing==2.0.2",
      "nose==1.3.6",
      #"backports.ssl-match-hostname==3.4.0.2",
    ]

  # dependencies to be installed with apt-get 
  $apt_get_dependencies  = [
      "wget",
      "python-pip", #there is a bug in the "pip" puppet package provider https://tickets.puppetlabs.com/browse/PUP-3829
    #   FIX: sudo ln -s /usr/bin/pip /usr/bin/pip-python
      "python-dev", # this is not in the requirements, but it was needed....
      "scala",
      "zlib1g-dev", #for sframe
      #"ccache", #for sframe
      "libpng-dev", #matplotlib
      "libjpeg8-dev", #matplotlib
      "libfreetype6-dev", #matplotlib
      'pkg-config', #http://stackoverflow.com/questions/9829175/pip-install-matplotlib-error-with-virtualenv
      "liblapack-dev", #scipy http://stackoverflow.com/questions/11114225/installing-scipy-and-numpy-using-pip
       "libblas-dev", #scipy
       "python-pandas",
       "libzmq-dev", #jupyter 
       "libxs-compat-libzmq-dev", #jupyter
       "python-jsonschema", #jupyter
    ]

}
