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
            }
        ],
        group_by =>[{name=>'id'},
                    {name=>'value'}],
        having => [
            {
              #  operator => 'IS NULl',
                field    => { name => 'id' },
                param =>   '2',

                
            },
            {
                name     => 'static 1',
                operator => 'IS NOT null',
                field    => { name => 'value' },
                param =>   \@test,

                
            },
        ],

        ,
    }
);

# $tasks->retrieve($dbh);
#my @new_id = $tasks->results();
# print Dumper(\@new_id);
 
 
  # ;    # print "dynamic_conditions=".Dumper($tasks->dynamic_conditions);

$tasks->add_having ({
     field    => { name => 'id' },
                param =>   '2',
});

$tasks->add_having ({
     field    => { name => 'idxxx' },
                param =>   '22',
});
# # warn("e\n");
# # $tasks->add_dynamic_condition({field   => $tasks->field_named("id"),
# # operator=>'=',
# # param   =>1});
# #
print Dumper($tasks);
print( $tasks->_select_clause() );

# print Dumper($tasks->fields->[15]);
#print Dumper( $tasks->joins() );
