class remaster::master ($puppet_master){
  Remaster::Master::Delete_node <<| master != $puppet_master |>>
}
