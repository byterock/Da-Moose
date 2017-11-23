package DBIx::DA::SQL::Roles::Field::Base;
use Data::Dumper;
use Moose::Role;

requires 'sql';

has expression => (
    is     => 'rw',
    isa    => 'Expression|Function',
    # coerce => 1,
);


has table => (
    is  => 'rw',
    isa => 'SQLName',
);

sub _field_sql {
    my $self = shift;
    my ($table) = @_;
    
        my $sql = "";
        if ($self->table()){
       $sql = $self->table()    }
    elsif ($table){
      $sql = $table->table()->name()         if ($table->can('table'));
       
      $sql = $table->clause->DA->table()->name()
         if ($table->can('clause'));
    }   

    return $sql . "." . $self->name();
}

1;
