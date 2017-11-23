package DBIx::DA::Constants::Aggregates;
use warnings;
use strict;
BEGIN {
  $DBIx::DA::Constants::Aggregate::VERSION = "0.01";
}
use constant AVG   =>'AVG';
use constant COUNT =>'COUNT';
use constant FIRST =>'FIRST';
use constant LAST  =>'LAST';
use constant MAX   =>'MAX';
use constant MIN   =>'MIN';
use constant SUM   =>'SUM';
use constant AGGREGATES =>{
             DBIx::DA::Constants::Aggregate::AVG   =>1,
             DBIx::DA::Constants::Aggregate::COUNT =>1,
             DBIx::DA::Constants::Aggregate::FIRST =>1,
             DBIx::DA::Constants::Aggregate::LAST  =>1,
             DBIx::DA::Constants::Aggregate::MAX   =>1,
             DBIx::DA::Constants::Aggregate::MIN   =>1,
             DBIx::DA::Constants::Aggregate::SUM   =>1,};
 1;
