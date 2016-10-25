class dependencies () inherits dependencies::params {
  notify { 'dependencies': }
#  anchor{ 'before_dependencies': } ->
  class{ "dependencies::install_apt_get_dependencies": } ->
  class{ "dependencies::install_matplotlib_dependencies": } ->
  #class{ "dependencies::install_sphinx_dependencies": } ->
  #class{ "dependencies::install_fabric_dependencies": } ->
  #class{ "dependencies::install_scala_dependency": } ->
  #class{ "dependencies::install_psycopg2_dependencies": } ->
  class{ "dependencies::install_pip_dependencies": } 
 # anchor{ 'after_dependencies': }
}
