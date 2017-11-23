package DBIx::DA::SQL::Roles::Oracle::Functions;

use Moose::Role;
use DBIx::DA::Constants::SQL;

sub concat {
   my $self = shift;
   my $options = $self->options();
   
   die "error: DBIx::DA::SQL::Roles::Oracle::Functions CONCAT! Must have 2 or more options!"
     if ( scalar(@{$options}) < 2 );
            
   
   my $sql =  sprintf("%s(%s,%s)",DBIx::DA::Constants::SQL::CONCAT(),$options->[0]->sql,$options->[1]->sql);

   foreach my $count (2 .. scalar(@{$options})-1){
       $sql =  sprintf("%s(%s,%s)",DBIx::DA::Constants::SQL::CONCAT(),$sql,$options->[$count]->sql);
   }   
   return $sql;
}


1;