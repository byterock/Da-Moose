#!/usr/bin/perl
use strict;
use warnings;
use lib qw( d:\GitHub\DataAccessor_moose\Da-Moose\DA\lib
);
use Data::Dumper;

use DBIx::DA::SQL;

use DBIx::DA::Join;

my $tasks = DBIx::DA::SQL->new(
    {
        table  => { name => 'user_cs' },
        fields => [
            {
                name        => 'email',
                is_identity => 1,
                aggregate   => 'COUNT',
                alias       => 'email'
            }
        ],
        where => [
            {
                
                open     =>  1,                name     => 'static 1',
                field    => { name => 'email' },
                to_field => {
                    name  => 'id',
                    table => 'invited_by'

                }
            },
            {
                name     => 'static 2',
                field    => { name => 'email' },
                to_field => {
                    name  => 'id',
                    table => 'invited_by'
                },
                close     =>  1,
                }
        ],

        ,
    }
);

$tasks->add_where(
    {
        #close     =>  1,
        condtion => 'or',
        name     => 'dynamic',
        field    => { name => 'invited_by_user_id' },
        to_field => {
            name  => 'id',
            table => 'invited_by'
        }
    }
);

# $tasks->add_where(
   # {
        # name     => 'dynamic 3',
        # field    => { name => 'invited_by_user_id' },
        # to_field => {
            # name  => 'email--',
            # table => 'invited_by'
        # }
    # }
# );

# $tasks->add_where(
   # {
        # name     => 'dynamic xxx',
        # field    => { name => 'invited_by_user_id' },
        # to_field => {
            # name  => 'xxxxx',
            # table => 'invited_by'
        # }
    # }
# );

 # print Dumper($tasks)
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
