class remaster::params{
  if $::is_pe {
    $service = 'pe-puppet'
  } else {
    $service = 'puppet'
  }
}
