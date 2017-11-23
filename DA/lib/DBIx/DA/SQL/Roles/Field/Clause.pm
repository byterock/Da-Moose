package DBIx::DA::SQL::Roles::Field::Clause;
use Data::Dumper;
use Moose::Role;

has [
    qw(value
      type
      source
      results
      sequence
      )
] => ( is => 'rw', isa => 'Str|Undef' );

# has [
    # qw(no_select
      # no_insert
      # no_update
      # returning
      # send_null
      # is_unique
      # is_identity
      # )
# ] => ( is => 'rw', isa => 'Bool|Undef' );



1;

