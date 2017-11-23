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
            {name  => 'detail_type_id',},
            { name  => 'active_ind'},],
        where =>[{field =>{ name    =>'notneeded',
                            function=>'substr',
                                  on=>{ name => 'email' },
                             options=>[{param=>4}]},
                  #condtion=>'=',
                       to=>{ param=>'john'}}                
            ],
 }
);

$tasks->add_field(
    { name => 'value' },
    {
        expression => '+',
        field    => {name     => 'detail_type_id'},
        to   => { name=>'test',
                  expression => '-',
                       field => {expression => '-',
                                       name=>'two',
                                      on => {name => 'value'},
                                      to_field=> {param   => 4}},
                    to_field => {name     => 'active_ind'}
                 }
        
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
#  print Dumper($tasks);

print( $tasks->_select_clause() );
 print Dumper($tasks->_params);