#!/usr/bin/perl
use strict;
use warnings;
use lib qw( e:\chemstore_m\DA-0.01\lib
);
use Data::Dumper;

use DBIx::DA::SQL;

use DBIx::DA::Join;


# my $join = DBIx::DA::Join->new({    clause        => 'LEFT',
                # to_table    => "user_cs",
                # conditions  => [{on_field=>
                                    # {name=>'invited_by_user_id'},
                                 # to_field=>
                                   # {name=>'id',
                                    # table=>'invited_by' }}],
                # });
# warn "JSP".Dumper($join);# exit;

my $tasks = DBIx::DA::SQL->new(
    {
        table  => { name => 'project_user' },
        fields => [
            {
                "is_identity" => 1,
                "name"        => "project_id"
            },
            {
                "is_identity" => 1,
                "name"        => "user_id"
            },
            { "name" => "private_ind" },
            { "name" => "active_ind" },
            { "name" => "notify_ind" },
            { "name" => "invited_on" },
            { "name" => "accecpted_on" },
            { "name" => "comments" },
            { "name" => "invited_by_user_id" },
            { "name" => "project_role_id" },
            {
                "alias" => "project_role_name",
                "name"  => "name",
                "table" => "project_role"
            },
            {
                "alias" => "project_role_label",
                "name"  => "label",
                "table" => "project_role"
            },
            {
                "alias" => "invited_by_first",
                "name"  => "first_name",
                "table" => "invited_by"
            },
            {
                "alias" => "invited_by_last",
                "name"  => "last_name",
                "table" => "invited_by"
            },
            {
                "table" => "user_cs",
                "name"  => "email"
            },
            {
                "function" => {
                    "name"    => "CONCAT",
                    "options" => [
                        {
                            "field" => {
                                "table" => "user_cs",
                                "name"  => "first_name"
                            }
                        },
                        { "staic" =>
                           {value=>"' '"} },
                        {
                            "field" => {
                                "table" => "user_cs",
                                "name"  => "last_name"
                            }
                        },
                        { "staic" =>
                           {value=>"'-'"} },   
                        {
                            "field" => {
                                "table" => "user_cs",
                                "name"  => "last_name"
                            }
                        }
                    ]
                },
                "alias" => "user_name",
                "name"  => "name"
            },
        ],
        "joins" => [
            {   name =>'j1',
                clause        => 'LEFT JOIN',
                to_table    => "user_cs",
                 table_alias=>'invited_by',
                conditions  => [{on_field=>
                                    {name=>'invited_by_user_id'},
                                 to_field=>
                                   {name=>'id',
                                    table=>'invited_by' }}],
            },
            {    name=>'j2',clause        => 'INNER JOIN',
                to_table    => "user_cs",
                conditions  => [{on_field=>
                                    {name=>'user_id'},
                                 to_field=>
                                   {name=>'id',
                                   }},
                                  {operator=>"and",
                                  on_field=>
                                    {name=>'user_id_n'},
                                 to_field=>
                                   {name=>'idww',
                                   }}],},
            # {    clause        => 'LEFT JOIN',
                # to_table    => "project_role",
                # conditions  => [{on_field=>
                                 # {name=>'project_role_id'},
                                 # to_field=>
                                   # {name=>'id',
                                    # }}],}
        ]
    }
);
   

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


# $tasks->joins->push({on_field=>
                                    # {name=>'email'},
                                 # to_field=>{staic =>{value=>"' '"} }
                                # });
 

# print Dumper($tasks->fields->[15]);
# print "count=". $tasks->join_count();
    # print "Joins=".Dumper($tasks->joins);
$tasks->add_join( {name=>'j3',
                clause        => 'LEFT JOIN',
                to_table    => "user_cs",
                 table_alias=>'invited_by',
                conditions  => [{on_field=>
                                    {name=>'invited_by_user_id_xx'},
                                 to_field=>
                                   {name=>'id',
                                    table=>'invited_by' }}],
            });

  print "Joins=".Dumper($tasks->dynamic_joins);
# #print "count=". $tasks->join_count();      
                      
  print($tasks->_select_clause())."/n";