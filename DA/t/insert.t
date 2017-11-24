#!/usr/bin/perl
use strict;
use warnings;



use lib qw( d:\GitHub\DataAccessor_moose\Da-Moose\DA\lib);
         #   D:\GitHub\DataAccessor_moose\Da-Moose\DA\lib\DBIx\DA
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
        table  => { name => 'address' },
        fields => [{name        => 'time_zone_id'},
                 {name        => 'country_id'},
                 {name =>'street'},
                 {name=>'postal_code'},
                 {name=>'city'},
                 {name=>'region_id'}
        ],
        ,
    }
);

# $tasks->retrieve($dbh);
#my @new_id = $tasks->results();
# print Dumper(\@new_id);
 
 
  # ;    # print "dynamic_conditions=".Dumper($tasks->dynamic_conditions);

# $tasks->add_having ({
     # field    => { name => 'id' },
                # param =>   '2',
# });

# $tasks->add_having ({
     # field    => { name => 'idxxx' },
                # param =>   '22',
# });
# # warn("e\n");
# # $tasks->add_dynamic_condition({field   => $tasks->field_named("id"),
# # operator=>'=',
# # param   =>1});
# #
# print Dumper($tasks);
print( $tasks->_insert_clause({time_zone_id=>'1',
                               country_id=>1,
                               street=>'110 main ste',
                               postal_code=>'m5h-ie6',
                               city=>'Toronto',
                               region_id=>1
                              }) );
               
# print Dumper($tasks->fields->[15]);
#print Dumper( $tasks->joins() );
