application lamp (
  $db_user,
  $db_password,
) {

  lamp::mysql { $name:
    db_user     => $db_user,
    db_password => $db_password,
    export      => Sql[$name],
  }

  lamp::webapp { $name:
    consume => Sql[$name],
  }

}
