class dependencies::install_pip_dependencies inherits dependencies{

  # define function for installing pip packages
  define install_package{
    $var = split($name, '==')
    $package_name  = "${var[0]}" # regsubst("${var[0]}", '\W+', '')
    $package_version  = "${var[1]}" #regsubst("${var[1]}", '\W+', '')
  # notify  {" installing '$package_name', version '$package_version'": }
      
    package {$package_name:
      provider  => pip,
      ensure  => $package_version,
      name  => $package_name, 
    }
  }

  install_package{ $pip_dependencies: }
}

