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
                name        => 'detail_type_id',
                 name        => 'value',
            }
        ],
        order_by =>[{name=>'detail_type_id',
                     },
                    {name=>'value',
                     order=>'desc'}],

        ,
    }
);

$tasks->add_order_by ({ name => 'id'},
                      { param=> 1},
                      { order=>'asc',
                      name    =>'notneeded',
                            function=>'substr',
                                  on=>{ name => 'email' },
                             options=>[{param=>4}]} );

$tasks->add_order_by ({ name => 'active_ind' });
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
print Dumper( $tasks->_params() );
