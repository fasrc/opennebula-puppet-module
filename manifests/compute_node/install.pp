# == Class one::compute_node::install
#
# Installation and Configuration of OpenNebula
# http://opennebula.org/
# Install all needed packages for OpenNebula node (compute node).
#
# === Author
# ePost Development GmbH
# (c) 2013
#
# Contributors:
# - Martin Alfke
# - Achim Ledermueller (Netways GmbH)
# - Sebastian Saemann (Netways GmbH)
#
# === License
# Apache License Version 2.0
# http://www.apache.org/licenses/LICENSE-2.0.html
#
class one::compute_node::install(
  $node_packages = $one::node_packages
) {
  class { 'sudo':
    purge               => false,
    config_file_replace => false,
  }
  package { $node_packages:
      ensure => latest,
  }
}
