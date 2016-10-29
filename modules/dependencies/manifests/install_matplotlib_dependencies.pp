class dependencies::install_matplotlib_dependencies inherits dependencies {

  # define function for matplotlib deps, taking care of versions
  define install_package{
    $var = split($name, '==')
    $package_name  = "${var[0]}" # regsubst("${var[0]}", '\W+', '')
    $package_version  = "${var[1]}" #regsubst("${var[1]}", '\W+', '')
  # notify  {" installing '$package_name', version '$package_version'": }

    file{"remove_pipbuild_dir_${package_name}":
      name  =>  "${pip_build_dir}/${package_name}",
      ensure => absent,
      recurse => true,
      force => true,
      purge => true,
    }

    package {$package_name:
      provider  => pip,
      ensure  => $package_version,
      name  => $package_name,
      require => File[ "remove_pipbuild_dir_${package_name}" ]
    }
  }

  install_package{ $matplotlib_dependencies: }

}

