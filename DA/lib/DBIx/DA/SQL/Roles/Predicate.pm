package DBIx::DA::SQL::Roles::Predicate;
use lib qw( E:\chemstore_m\DA-0.01\lib);
use DBIx::DA::Constants::SQL;

use Moose::Role;

requires 'sql';

use MooseX::Aliases;

# has name => (
      # is         => 'rw',
     # isa => 'Str',
# );    

has clause => (
    is  => 'rw',
    isa => 'Object',
);


has operator => (
    is  => 'rw',
    isa => 'SQLOperator',
    default=>'='

);



1;
