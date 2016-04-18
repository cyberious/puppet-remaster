class remaster::agent::delete {
  assert_private()
  #Export resource for master and console to pickup and delete
  if $remaster::master_delete {
    @@remaster::master::delete_node {$::fqdn:
      master => $remaster::puppet_master,
    }
  }
  if $remaster::console_delete {
    @@remaster::console::delete_node {$::fqdn:
      master => $remaster::puppet_master,
    }
  }

}
