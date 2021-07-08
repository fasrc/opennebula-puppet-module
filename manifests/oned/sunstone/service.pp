# == Class one::oned::sunstone::service
#
# Installation and Configuration of OpenNebula
# http://opennebula.org/
#
# === Author
# ePost Development GmbH
# (c) 2013
#
# Contributors:
# - Martin Alfke
#
# === License
# Apache License Version 2.0
# http://www.apache.org/licenses/LICENSE-2.0.html
#
class one::oned::sunstone::service (
  $sunstone_passenger = $one::sunstone_passenger,
  $sunstone_novnc     = $one::sunstone_novnc,
  $ha_setup           = $one::ha_setup,
){
  if $sunstone_passenger {
    $srv_ensure = stopped
    $srv_enable = false
  } elsif ($ha_setup) {
    $srv_ensure = undef
    $srv_enable = false
  } else {
    $srv_ensure = running
    $srv_enable = true
  }

  service { 'opennebula-sunstone':
    ensure  => $srv_ensure,
    enable  => $srv_enable,
    require => Service['opennebula'],
  }

  if ($ha_setup) {
    $_sunstone_novnc_enable = false
    $_sunstone_novnc_ensure = undef
  } else {
    $_sunstone_novnc_enable = $sunstone_novnc
    $_sunstone_novnc_ensure = $sunstone_novnc ? {
      true    => running,
      default => stopped,
    }
  }

  service { 'opennebula-novnc':
    ensure => $_sunstone_novnc_ensure,
    enable => $_sunstone_novnc_enable,
  }
}
