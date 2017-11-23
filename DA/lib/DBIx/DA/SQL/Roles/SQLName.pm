package DBIx::DA::SQL::Roles::SQLNamex;

use Moose::Role;

 has name => (
      is         => 'rw',
     required   => 1,
     isa => 'SQLName',
    );    1;