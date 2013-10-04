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
        command => "/usr/bin/vagrant plugin install ${plugin}",
        unless  => "/usr/bin/vagrant plugin list | grep -x ${plugin}",
      }
    }
    'absent': {
      exec { "uninstall-${plugin}":
        command => "/usr/bin/vagrant plugin uninstall ${plugin}",
        onlyif  => "/usr/bin/vagrant plugin list | grep -x ${plugin}",
      }
    }
    /^(\d)\.(\d)\.(\d)$/: {
      exec { "install-${plugin}":
        command => "/usr/bin/vagrant plugin install ${plugin}",
        unless  => "/usr/bin/vagrant plugin list | grep -x ${plugin}",
      }
    }
    default: { fail("${ensure} is not a valid option, present/absent/1.2.3 version") }
  }
}
