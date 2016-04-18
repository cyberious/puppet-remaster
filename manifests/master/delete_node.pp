#
define remaster::master::delete_node (
  $node = $name,
  $master = $servername,
  $cert_delete_style = 'clean'
) {

  validate_re($cert_delete_style, ['^clean$', '^revoke$'])
  Exec {
    path => $::path,
  }
  exec {"deactivate node ${node}":
    command => "/opt/puppet/bin/puppet node deactivate ${node}",
    onlyif  => "/opt/puppet/bin/puppet node status ${node} | grep Current"
  }

  exec {"delete node ${node}":
    command => "/opt/puppet/bin/puppet cert ${cert_delete_style} ${node}",
    onlyif  => "/opt/puppet/bin/puppet cert list ${node}",
  }
}
