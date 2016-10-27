class dependencies::install_spark_dependency inherits dependencies {


  exec { 'get_spark':
    cwd => '/home/ubuntu',
    creates => '/home/ubuntu/spark.tgz',
    command  => "/usr/bin/wget $spark -O spark.tgz && /bin/tar -xf spark.tgz -C /home/ubuntu/spark --strip-components=1",
  }

  file { '/home/ubuntu/spark':
    ensure => 'directory',
    owner  => 'ubuntu',
    group  => 'ubuntu',
    before => Exec['get_spark']
  }


 #package {'scala':    
 #   ensure    => installed,
 #   provider  => dpkg,
 #   source  => "$scala_deb" 
#    source    => 'puppet:///modules/gitlab/ruby2-repo/ruby2.0_2.0.0.299-2_amd64.deb',  
#    source    => 'puppet:///modules/gitlab/ruby2.0_2.0.0.299-2_amd64.deb', 
#    source    => 'http:///mirrors.xmission.com/ubuntu/pool/universe/r/ruby2.0/ruby2.0_2.0.0.299-2_amd64.deb', 
#    source    => '/vagrant/files/ruby2.0_2.0.0.299-2_amd64.deb',
#  }
}
