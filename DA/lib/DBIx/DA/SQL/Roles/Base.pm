package DBIx::DA::SQL::Roles::Base;

use Moose::Role;

 has name => (
      is         => 'rw',
        isa => 'Str',
    );    1;