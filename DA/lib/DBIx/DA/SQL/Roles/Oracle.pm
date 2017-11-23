package DBIx::DA::SQL::Roles::Oracle;

use Moose::Role;

sub _returning_clause {
    my $self = shift;
    return $self->returning->sql()
      if $self->returning();
}


sub _hierarchical_clause {
    my $self = shift;
    my $sql  = " ";

    # foreach my $join ($self->joins()){
    # $sql.= $join->sql();
    # }
    foreach my $join ( $self->hierarchical_joins() ) {
        $sql .= $join->sql();
    }
    return $sql;
}
1;