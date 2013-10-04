define vagrant_plugin (
  $plugin = $title,
  $ensure = present,
) {

  Exec {
    path => "/usr/bin",
  }

  case $ensure {
    'present': {
      exec { "install-${plugin}":
        command => "vagrant plugin install ${plugin}",
        unless  => "vagrant plugin list | grep -x ${plugin}",
      }
    }
    'absent': {
      exec { "uninstall-${plugin}":
        command => "vagrant plugin uninstall ${plugin}",
        onlyif  => "vagrant plugin list | grep -x ${plugin}",
      }
    }
    /^(\d)\.(\d)\.(\d)$/: {
      exec { "install-${plugin}":
        command => "vagrant plugin install ${plugin}",
        unless  => "vagrant plugin list | grep -x ${plugin}",
      }
    }
    default: { fail("${ensure} is not a valid option, present/absent/1.2.3 version") }
  }
}
