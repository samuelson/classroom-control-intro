define lamp::mysql (
  $db_user,
  $db_password,
  $host     = $::hostname,
  $database = $name,
) {

  class { '::mysql::server':
    service_provider => 'debian',
    override_options => {
      'mysqld' => { 'bind-address' => '0.0.0.0' }
    },
  }

  mysql::db { $name:
    user     => $db_user,
    password => $db_password,
    host     => '%',
    grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE'],
  }

  class { '::mysql::bindings':
    php_enable       => true,
    php_package_name => 'php5-mysql',
  }

}
Lamp::Mysql produces Sql {
  user     => $db_user,
  password => $db_password,
  host     => $host,
  database => $database,
}
