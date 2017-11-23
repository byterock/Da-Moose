package DBIx::DA::SQL::Roles::Paramameter;
use lib qw( E:\chemstore_m\DA-0.01\lib);
use DBIx::DA::Constants::SQL;

use Moose::Role;
use MooseX::Aliases;


    has value  => ( is => 'rw', isa => 'Str|ArrayRef|Undef' );
    
     # has expression => (
      # is         => 'rw',
      # isa => 'Object',
    # );
    # has name => (
      # is         => 'rw',
      # isa => 'Str',
    # );
      
    has _use_named_params => ( is => 'ro',
                               default => 0,
                               isa => 'Bool' );

    sub sql {
        my $self = shift;

        #warn("Param name=".ref($self)."\n");
        #warn("Param value=".$self->value()."\n");

        # my $ = $self->_parent();
        # my $clause_ref = $$predicate_ref->_parent();
        # my $da_ref = $$clause_ref->_parent();
        # $$self->_parent()->push__params($self);
        if ( $self->_predicate->clause->DA->use_named_params() ) {
            die "error: You must supply a 'bName' when using a Named Prarameter!"
              unless($self->name());
            return " :p_" . $self->name();
        }
        else {
            return " ? ";
        }
    }
 
1;