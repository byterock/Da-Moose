#!/usr/bin/perl
use strict;
use warnings;
use lib qw( e:\chemstore_m\DA-0.01\lib
);
use Data::Dumper;

use DBIx::DA::SQL;

use DBIx::DA::Join;

my $tasks = DBIx::DA::SQL->new(
    {
        table  => { name => 'user_cs' },
        fields => [
            {
                name          => 'email',
                "is_identity" => 1,
                aggregate     => 'COUNT',
                alias         => 'email'
            } 
        ],
        group_by => 
                {
                    fields=>[{
                    name      => 'email',
                    no_select => 1,
                }]
                }
            
        ,
    }
);

$tasks->add_where( {on_field=>
                                    {name=>'invited_by_user_id'},
                                to_field=>
                                   {name=>'id',
                                    table=>'invited_by' }});
                                    
 print "dynamic_conditions=".Dumper($tasks->dynamic_conditions);
#  $self->add_join(
# {
# table_name  => $opt->{to_table},
# table_alias => $opt->{table_alias},
# type        => DBIx::DA::Constants::SQL::LEFT,
# conditions  => {
# field    => $on_param,
# operator => $operator,
# param    => $to_param
# }
# }
# );
# # warn("e\n");
# # $tasks->add_dynamic_condition({field   => $tasks->field_named("id"),
# # operator=>'=',
# # param   =>1});
# #

print( $tasks->_select_clause() );

# print Dumper($tasks->fields->[15]);
#print Dumper( $tasks->joins() );
