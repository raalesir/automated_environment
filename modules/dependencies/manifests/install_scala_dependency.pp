class dependencies::install_scala_dependency inherits dependencies {


exec { 'install issuetracker':
    command  => "/usr/bin/wget $scala_deb && dpkg -i scala scala-2.11.7.deb"
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
