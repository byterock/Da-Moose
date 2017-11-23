package DBIx::DA::SQL::Roles::Clause;

use Moose::Role;

 has DA => (
     is       => 'rw',
#     required => 1,
     isa => 'DBIx::DA::SQL',
    );    




sub _set_predicates {
   my $self = shift;
   foreach my $predicate ( @{ $self->predicates() } ) {
     $predicate->clause($self);
   }
}

1;