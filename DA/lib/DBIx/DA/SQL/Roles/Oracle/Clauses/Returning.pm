 package DBIx::DA::SQL::Roles::Oracle::Clauses::Returning;

use Moose::Role;
use DBIx::DA::Constants::SQL;

    has [qw(_parent)] => ( is => 'rw', isa => 'Str|Undef' );
    has [qw(params)]  => ( is => 'rw', isa => 'ArrayRef|Undef' );

    sub sql {
        my $self      = shift;
        my $delimiter = "";
        my $field_str = "";
        my $param_str = "";
        my $da_ref    = $self->_parent();
        foreach my $param ( $self->params() ) {
            my $field_tmp = $param->name();
            if ( $param->aggregate() ) {    #some sort of function on this
                $field_tmp .= $param->aggregate() . "($field_tmp)";
            }

            $field_str .= $delimiter . $field_tmp;
            my $param_tmp = "?";
            if ( $$da_ref->use_named_params() ) {
                $param_tmp = " :p_" . $param->name();
            }
            $param_str .= $delimiter . $param_tmp;
            $delimiter = ", ";
        }
        return " RETURNING " . $field_str . " INTO " . $param_str;
    }
}

