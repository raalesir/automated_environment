class dependencies::install_apt_get_dependencies inherits dependencies {

  # function for the apt-get install 
  define install_package{

    $var = split($name, ':')
    $package_name = "${var[0]}"
#    $package_version = "${var[1]}"

    notify  { " installing '$package_name' ": }

    package { $package_name:
      provider  => apt,
      name      =>  $package_name,
      ensure    =>  present,
    }
  }
  install_package{ $apt_get_dependencies: }
}
