#!/usr/bin/perl
use strict;
use warnings;

use lib qw( e:\chemstore_m\DA-0.01\lib);

# D:/Perl64/site/lib
# D:/Perl64/lib);
use Data::Dumper;

# use DBI;

use DBIx::DA::SQL;

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
                name  => 'id',
                alias => 'contact_id'
            }, ],
         # where =>[{ field    => { name => 'email' },
                # to_field => {
                    # name  => 'id',
                    # table => 'invited_by'

                # }}]
       

    }
);

$tasks->add_field(
    { name => 'value' },
    {
        function => 'substr',
        on    => {  
                function => 'substr',
                on       => { name => 'value' },
                options  => [ { param =>11} ],
                name     => 'test2',
             },
        options  => [
          
            { param => 3 }],
        name     => 'test',
        
    }
);

# {param=>{value=>'3'}}
# ]},
# {name=>'substr',
# options=>[{field=>{name=>'value'},
# param=>{value=>'11'}}
# ]}
# ]});

# $tasks->add_field(
# { name=>'5' ,
# functions=>[{name=>'CONCAT',
# options=>[{field=>{name=>'value'},
# param=>{value=>'66'},
# }]}]});
# $tasks->add_field( {
# "functions" => [{
# "name"    => "CONCAT",
# "options" => [
# {
# "field" => {
# "table" => "user_cs",
# "name"  => "first_name"
# }
# },
# { "param" =>
# {value=>"' '"} },
# {
# "field" => {
# "table" => "user_cs",
# "name"  => "last_name"
# }
# },
# { "param" =>
# {value=>"'-'"} },
# {
# "field" => {
# "table" => "user_cs",
# "name"  => "last_name"
# }
# }
# ]
# }],
# "alias" => "user_name",
# "name"  => "5"
# },);
 # print Dumper($tasks);

print( $tasks->_select_clause() );
