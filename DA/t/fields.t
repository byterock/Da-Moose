#!/usr/bin/perl
use strict;
use warnings;



use lib qw( e:\chemstore_m\DA-0.01\lib);
 # D:/Perl64/site/lib
 # D:/Perl64/lib);
use Data::Dumper;

# use DBI;

use  DBIx::DA::SQL;

        # "DBI:Oracle:",
        # "HR",
         # "hr",
        # {"LongTruncOk"=>1,
         # "LongReadLen"=>2000000, 
         # "RaiseError"=> 1,
         # FetchHashKeyName=>'NAME_lc'}
    # );

 

    {
        table  => { name => 'contact_detail' },
        fields => [
                {name        => 'detail_type_id',
                 alias       =>'Type'},
                {name        => 'value'},
           
        ],
 
    }
);



$tasks->add_field({ name => 'id' },
                   );

# print Dumper($tasks);
 

print( $tasks->_select_clause() );