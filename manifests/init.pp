# Class: remaster
# ===========================
#
# Full description of class remaster here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'remaster':
#      puppet_master => 'my.new.master',
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class remaster (
  $puppet_master,
  $ssldir         = "${::puppet_confdir}/ssl",
  $service        = $remaster::params::service,
  $master_delete  = true,
  $console_delete = true,
) inherits remaster::params {


  ensure_resource('service', $service, {
    'ensure' => 'running',
    'enable' => true,
  })
  augeas{ 'set_config':
    incl    => "${::puppet_confdir}/puppet.conf",
    lens    => 'Puppet.lns',
    changes => [
      "set main/server '${puppet_master}'",
    ]
  }
  exec { 'delete ssldir':
    command     => "rm -rf ${ssldir}",
    path        => $::path,
    refreshonly => true,
  }
  Augeas['set_config']~>
  Exec['delete ssldir']~>
  Service[$service]~>
  class { 'remaster::agent::delete': }
}
