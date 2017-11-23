package DBIx::DA::SQL::Roles::Oracle::Joins::Hierachical;

use Moose::Role;
use DBIx::DA::Constants::SQL;

    has [
        qw(start_value start_field parent_field child_field _parent
          )
    ] => ( is => 'rw', isa => 'Str|Undef' );

    sub validate_start_field {
        my $self = shift;
        my ($opt) = @_;

        # Check $opt
        ref($opt) eq 'DBIx::DA::Field'
          || die(
"ERROR: DBIx::DA::HierachicalJoin::start_field, must be 'DBIx::DA::Field' object."
          );
        return 1;
    }

    sub validate_parent_field {
        my $self = shift;
        my ($opt) = @_;

        # Check $opt
        ref($opt) eq 'DBIx::DA::Field'
          || die(
"ERROR: DBIx::DA::HierachicalJoin::parent_field, must be 'DBIx::DA::Field' object."
          );
        return 1;
    }

    sub validate_child_field {
        my $self = shift;
        my ($opt) = @_;

        # Check $opt
        ref($opt) eq 'DBIx::DA::Field'
          || die(
"ERROR: DBIx::DA::HierachicalJoin::child_field, must be 'DBIx::DA::Field' object."
          );
        return 1;
    }

    sub sql {
        my $self = shift;

        my $connector = ' = ' . $self->start_value();
        $connector = DBIx::DA::Constants::SQL::IS_NULL
          if ( uc( $self->start_value() ) eq DBIx::DA::Constants::SQL::NULL );

        my $sql =
            " START WITH "
          . $self->start_field->sql()
          . $connector
          . " CONNECT BY PRIOR "
          . $self->child_field->sql() . " = "
          . $self->parent_field->sql();

        return $sql;
    }
}
