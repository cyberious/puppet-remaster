#
define remaster::master::delete_node ($node = $name, $master = $servername) {
  Exec {
    path => $::path,
  }
  exec {"deactivate node ${node}":
    command => "/opt/puppet/bin/puppet node deactivate ${node}",
    onlyif  => "/opt/puppet/bin/puppet node status ${node} | grep Current"
  }

  exec {"delete node ${node}":
    command => "/opt/puppet/bin/puppet cert clean ${node}",
    onlyif  => "/opt/puppet/bin/puppet cert list ${node}",
  }
}
