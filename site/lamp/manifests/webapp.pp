define lamp::webapp (
  $db_user,
  $db_password,
  $db_host,
  $db_name,
  $docroot = '/var/www/html'
) {
  class { 'apache':
    default_mods  => false,
    mpm_module    => 'prefork',
    default_vhost => false,
  }

  apache::vhost { $name:
    port           => '80',
    docroot        => $docroot,
    directoryindex => ['index.php','index.html'],
  }

  package { 'php5-mysql':
    ensure => installed,
    notify => Service['httpd'],
  }

  include apache::mod::php

  $indexphp = @("EOT"/)
    <?php
    \$conn = mysql_connect('${db_host}', '${db_user}', '${db_password}');
    if (!\$conn) {
      echo 'Connection to ${db_host} as ${db_user} failed';
    } else {
      echo 'Connected successfully to ${db_host} as ${db_user}';
    }
    ?>
    | EOT

  file { "${docroot}/index.php":
    ensure  => file,
    content => $indexphp,
  }

}
Lamp::Webapp consumes Sql {
  db_user     => $user,
  db_password => $password,
  db_host     => $host,
  db_name     => $database,
}
