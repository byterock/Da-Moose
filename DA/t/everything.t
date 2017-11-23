#!/usr/bin/perl
use strict;
use warnings;




use lib qw( e:\chemstore_m\DA-0.01\lib);
 # D:/Perl64/site/lib
 # D:/Perl64/lib);
use Data::Dumper;

# use DBI;

use  DBIx::DA::SQL;

# my  $dbh = DBI->connect(
        # "DBI:Oracle:",
        # "HR",
         # "hr",
        # {"LongTruncOk"=>1,
         # "LongReadLen"=>2000000, 
         # "RaiseError"=> 1,
         # FetchHashKeyName=>'NAME_lc'}
    # );

my @test = qw(6 2 3);


my $tasks = DBIx::DA::SQL->new(
    {
        table  => { name => 'contact_detail' },
        fields => [
            {
                name        => 'value',
            },
             {
                name        => 'name',
                table       => 'detail_type'
            }
        ],
        joins =>[{
                clause      => 'LEFT JOIN',
                to_table    => "detail_type_JOIN",
                conditions  => [
                    {
                        on_field => { name => 'detail_type_id_Join2' },
                        to_field => {
                            name  => 'id',
                            table => 'detail_type_Join_2'
                        }
                    }
                ],
            }],
        group_by =>[{name=>'detail_type_id'},
                    {name=>'value'},
                    {name        => 'name',
                table       => 'detail_type'}],
        having => [
            {
              #  operator => 'IS NULl',
                field    => { name => 'detail_type_id' },
                param =>   '3',

                
            },
            {
                operator => 'IS NOT null',
                field    => { name => 'value' },
                param =>   \@test,

                
            },
            ],
        where => [{
                operator => 'Like',
                field    => { name => 'value' },
                param =>   '%hotmail.com',

                
            }],
         order_by => [{
                 name => 'value',order=>'desc' ,
            }],
        ,

        ,
    }
);

# $tasks->retrieve($dbh);
#my @new_id = $tasks->results();
# print Dumper(\@new_id);
 # print Dumper($tasks);
 
  # ;    # print "dynamic_conditions=".Dumper($tasks->dynamic_conditions);

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
