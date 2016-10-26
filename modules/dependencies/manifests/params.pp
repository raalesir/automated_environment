class dependencies::params{
 
  #$spark_deb = "http://www.scala-lang.org/files/archive/scala-2.11.7.deb"
  $spark_deb = "http://d3kbcqa49mib13.cloudfront.net/spark-2.0.1-bin-hadoop2.7.tgz"

  $pip_dependencies  = [
      "SFrame==2.1",
      "seaborn==0.7.1",
      "findspark==1.1.0",
      "py4j==0.10.4",
      "ipython==5.1.0",
  ]

  $matplotlib_dependencies =[
      #"distribute==0.6.49",
      #"numpy==1.8.1",
      #"python-dateutil==2.2",
      #"tornado==3.2.2",
      #"pyparsing==2.0.2",
      "nose==1.3.6",
      #"backports.ssl-match-hostname==3.4.0.2",
    ]

  $apt_get_dependencies  = [
      "python-pip", #there is a bug in the "pip" puppet package provider https://tickets.puppetlabs.com/browse/PUP-3829
    #   FIX: sudo ln -s /usr/bin/pip /usr/bin/pip-python
      #"agg-devel",
      #"freetype-devel",
      #"libjpeg-turbo-devel",
      #"libpng-devel",
      #"libjpeg-turbo",
      #"zlib",
      #"libtiff",
      #"freetype",
      #"lcms2",
      #"libwebp",
      #"tcl",
      #"openjpeg",
      "python-dev", # this is not in the requirements, but it was needed....
      #"$sshfs",
      "scala",
      "zlib1g-dev", #for sframe
      #"ccache", #for sframe
    ]

}
