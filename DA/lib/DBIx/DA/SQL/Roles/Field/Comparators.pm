package DBIx::DA::SQL::Roles::Field::Comparators;use lib qw( d:\GitHub\DataAccessor_moose\Da-Moose\DA\lib);
use DBIx::DA::Constants::SQL;

use Moose::Role;
use MooseX::Aliases;
has left => ( 
    is       => 'rw',
    isa      => 'Field|SelectField|Function|Expression|Param',
    required => 1,
    coerce   => 1,
    alias    => [qw(this on_field field on)]
);

has right => (
    is       => 'rw',
    isa      => 'SelectField|ArrayRefOfFunctionOptions|ArrayRefofParams|Param|Field|ArrayRefofFields',#Expression|
    required => 1,
    coerce   => 1,
    alias    => [qw(that to_field param options to )]
);

has open_parenthes => (
    is  => 'rw',
    isa => 'Int',
    default => 0,
    alias    => [qw(open open_paren)]

);


has close_parenthes => (
    is  => 'rw',
    isa => 'Int',
    default => 0,
    alias    => [qw(close close_paren)]

);
1;