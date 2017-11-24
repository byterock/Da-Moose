package DBIx::DA::SQL::Roles::Predicate;
use lib qw( d:\GitHub\DataAccessor_moose\Da-Moose\DA\lib);
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
