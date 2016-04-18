define remaster::console::delete_node (
  $master,
  $node = $name,
  ){
  Exec{
    path => "${::path};/opt/puppet/bin",
  }
  $query = [
    "curl https://${::fqdn}:4433/classifier-api/v1/node/${node}",
    "--cert /etc/puppetlabs/puppet/ssl/certs/${::fqdn}.pem",
    "--key /etc/puppetlabs/puppet/ssl/private_keys/${::fqdn}.pem",
    '--cacert /etc/puppetlabs/puppet/ssl/certs/ca.pem',
    '-H "Content-Type: application/json"',
    '| grep "Resource not found"'
  ]
  exec { "clean node ${node}":
    environment => 'RAILS_ENV=production',
    command     => "rake -f /opt/puppet/share/puppet-dashboard/Rakefile node:del[${node}]",
    onlyit      => join($query,' '),
  }

}
