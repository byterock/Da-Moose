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
        table  => { name => 'contact_detail' },
        fields => [
            {
                name        => 'value',
            }
        ],
        where => [
            {
                name     => 'static 1',
                operator => 'like',
                field    => { name => 'value' },
                param =>   '%blogs%',

                
            },
        ],

        ,
    }
);


 print Dumper($tasks)
  ;    # print "dynamic_conditions=".Dumper($tasks->dynamic_conditions);

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
