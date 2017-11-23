package Constants::OrderBy;
use warnings;
use strict;
BEGIN {
  $DBIx::DA::Constants::Order_by::VERSION = "0.01";
}
use constant ASC   =>' ASC ';
use constant DESC  =>' DESC ';
use constant ORDER_BY =>{
             DBIx::DA::Constants::Order_by::ASC   =>1,
             DBIx::DA::Constants::Order_by::DESC  =>1,};
 1;
