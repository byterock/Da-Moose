package DBIx::DA::SQL::Roles::Clause::Join;

use DBIx::DA::Constants::SQL;

use Moose::Role;
      

    has clause => (
       is         => 'ro',
       isa        => DBIx::DA::Constants::SQL::JOIN,
    );
    
1;