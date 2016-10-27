class dependencies () inherits dependencies::params {
 
  file { '/etc/profile.d/append_spark_bin.sh':
    mode    => '644',
    content => 'PATH=$PATH:/home/ubuntu/spark/bin',
    before => Exec["source_etc_profile"]
  }
  file { '/etc/profile.d/append_spark_home.sh':
    mode    => '644',
    content => 'SPARK_HOME=/home/ubuntu/spark',
    before => Exec["source_etc_profile"]
  }
  exec { "source_etc_profile":
    command => "/bin/bash -c 'source /etc/profile'",
  }

  notify { 'dependencies': }
#  anchor{ 'before_dependencies': } ->
  class{ "dependencies::install_apt_get_dependencies": } ->
  class{ "dependencies::install_matplotlib_dependencies": } ->
  #class{ "dependencies::install_sphinx_dependencies": } ->
  #class{ "dependencies::install_fabric_dependencies": } ->
  class{ "dependencies::install_spark_dependency": } ->
  #class{ "dependencies::install_psycopg2_dependencies": } ->
  class{ "dependencies::install_pip_dependencies": } 
 # anchor{ 'after_dependencies': }
}
