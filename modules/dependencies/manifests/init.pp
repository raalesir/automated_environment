class dependencies () inherits dependencies::params {
  
  # add spark/bin to the PATH 
  file { '/etc/profile.d/append_spark_bin.sh':
    mode    => '644',
    content => 'PATH=$PATH:/home/ubuntu/spark/bin',
    before => Exec["source_etc_profile"]
  }
  # creating SPARK_HOME. Needed for Jupyter
  file { '/etc/profile.d/append_spark_home.sh':
    mode    => '644',
    content => 'export SPARK_HOME=/home/ubuntu/spark',
    before => Exec["source_etc_profile"]
  }
  # source the file to make variables above active
  exec { "source_etc_profile":
    command => "/bin/bash -c 'source /etc/profile'",
  }

  # install dependencies for the different packages
  notify { 'dependencies': }
#  anchor{ 'before_dependencies': } ->
  class{ "dependencies::install_apt_get_dependencies": } ->
  class{ "dependencies::install_matplotlib_dependencies": } ->
  class{ "dependencies::install_spark_dependency": } ->
  class{ "dependencies::install_pip_dependencies": } 
 # anchor{ 'after_dependencies': }
}
