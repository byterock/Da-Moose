package DBIx::DA::Constants::Join;
use warnings;
use strict;
BEGIN {
  $DBIx::DA::Constants::Join::VERSION = "0.01";
}
use constant JOIN        =>'JOIN';
use constant OUTER       =>'OUTER ';
use constant OUTER_LEFT  =>'OUTER LEFT';
use constant OUTER_RIGHT =>'OUTER RIGHT';
use constant OUTER_FULL  =>'OUTER FULL';
use constant INNER       =>'INNER';
use constant INNER_LEFT  =>'INNER LEFT';
use constant INNER_RIGHT =>'INNER RIGHT';
use constant INNER_FULL  =>'INNER FULL';
use constant CONNECT_BY  =>'CONNECT BY';
use constant CONNECT_BY_PRIOR =>'CONNECT BY PRIOR';
use constant START_WITH  =>'START WITH';
use constant JOINS =>{
             DBIx::DA::Constants::Join::OUTER       =>1,
             DBIx::DA::Constants::Join::OUTER_LEFT  =>1,
             DBIx::DA::Constants::Join::OUTER_RIGHT =>1,
             DBIx::DA::Constants::Join::OUTER_FULL  =>1,
             DBIx::DA::Constants::Join::INNER       =>1,
             DBIx::DA::Constants::Join::INNER_LEFT  =>1,
             DBIx::DA::Constants::Join::INNER_RIGHT =>1,
             DBIx::DA::Constants::Join::CONNECT_BY  =>1,
             DBIx::DA::Constants::Join::CONNECT_BY_PRIOR =>1,
             DBIx::DA::Constants::Join::START_WITH  =>1,};
 1;
