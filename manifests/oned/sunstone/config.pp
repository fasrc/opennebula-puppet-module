# == Class one::oned::sunstone::config
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
# - Achim Ledermueller (Netways GmbH)
# - Sebastian Saemann (Netways GmbH)
#
# === License
# Apache License Version 2.0
# http://www.apache.org/licenses/LICENSE-2.0.html
#
class one::oned::sunstone::config (
  $listen_ip               = $one::sunstone_listen_ip,
  $enable_support          = $one::enable_support,
  $enable_marketplace      = $one::enable_marketplace,
  $tmpdir                  = $one::sunstone_tmpdir,
  $sessions                = $one::sunstone_sessions,
  $vnc_proxy_port          = $one::vnc_proxy_port,
  $vnc_proxy_support_wss   = $one::vnc_proxy_support_wss,
  $vnc_proxy_cert          = $one::vnc_proxy_cert,
  $vnc_proxy_key           = $one::vnc_proxy_key,
  $vnc_proxy_ipv6          = $one::vnc_proxy_ipv6,
  $sunstone_logo_png       = $one::sunstone_logo_png,
  $sunstone_logo_small_png = $one::sunstone_logo_small_png,
) inherits one {

  $one::sunstone::root = '/etc/one/sunstone-views'

  if $version_gte_5_8 = true {
    $one::sunstone::root = $one::sunstone::root/mixed
  }

  File {
    owner   => 'root',
    group   => 'oneadmin',
  }
  file { '/usr/lib/one/sunstone':
    ensure  => directory,
    owner   => 'oneadmin',
    mode    => '0755',
    recurse => true,
  } ->
  file { '/etc/one/sunstone-server.conf':
    ensure  => file,
    content => template("one/${::one::template_path}/sunstone-server.conf.erb"),
    notify  => Service['opennebula-sunstone'],
  } ->
  file { '/etc/one/sunstone-views.yaml':
    ensure  => file,
    mode    => '0640',
    content => template("one/${::one::template_path}/sunstone-views.yaml.erb"),
  } ->
  file { '${one::sunstone::root}/admin.yaml':
    ensure  => file,
    mode    => '0640',
    content => template("one/${::one::template_path}/sunstone-views-admin.yaml.erb"),
  } ->
  file { '${one::sunstone::root}/user.yaml':
    ensure  => file,
    mode    => '0640',
    content => template("one/${::one::template_path}/sunstone-views-user.yaml.erb"),
  }

  if $one::version_gte_5_0 {
    file {'${one::sunstone::root}/cloud.yaml':
      ensure  => file,
      mode    => '0640',
      content => template("one/${::one::template_path}/sunstone-views-cloud.yaml.erb"),
      require => File['${one::sunstone::root}/user.yaml'],
    }
  }

  if $sunstone_logo_png != 'undef' or $sunstone_logo_small_png != 'undef' {
    file { '/usr/lib/one/sunstone/public/images':
      ensure => directory,
      mode   => '0755',
    }
  }

  if $sunstone_logo_png != 'undef' {
    file { '/usr/lib/one/sunstone/public/images/custom_logo.png':
      ensure  => file,
      mode    => '0644',
      source  => $sunstone_logo_png,
      require => File['/usr/lib/one/sunstone/public/images'],
    }
  }

  if $sunstone_logo_small_png != 'undef' {
    file { '/usr/lib/one/sunstone/public/images/custom_logo_small.png':
      ensure  => file,
      mode    => '0644',
      source  => $sunstone_logo_small_png,
      require => File['/usr/lib/one/sunstone/public/images'],
    }
  }
}
