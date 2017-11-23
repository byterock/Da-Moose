package DBIx::DA::Constants::DA;
use warnings;
use strict;
BEGIN {
  $DBIx::DA::Constants::DA::VERSION = "0.01";
}

use constant NONE    =>'NONE';
use constant CREATE  =>'C';
use constant RETRIEVE=>'R';
use constant UPDATE  =>'U';
use constant DELETE  =>'D';

use constant OPERATION_TYPES =>{
             DBIx::DA::Constants::DA::CREATE   =>1,
             DBIx::DA::Constants::DA::RETRIEVE =>1,
             DBIx::DA::Constants::DA::UPDATE   =>1,
             DBIx::DA::Constants::DA::DELETE   =>1,};
 1;
