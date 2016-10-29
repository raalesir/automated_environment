class dependencies::install_spark_dependency inherits dependencies {

  # download and extract spark binaries to the /home/ubuntu/spark
  exec { 'get_spark':
    cwd => '/home/ubuntu',
    creates => '/home/ubuntu/spark.tgz',
    command  => "/usr/bin/wget $spark -O spark.tgz && /bin/tar -xf spark.tgz -C /home/ubuntu/spark --strip-components=1",
  }

  # creating /home/ubuntu/spark
  file { '/home/ubuntu/spark':
    ensure => 'directory',
    owner  => 'ubuntu',
    group  => 'ubuntu',
    before => Exec['get_spark']
  }


}
