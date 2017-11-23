package DBIx::DA::Constants::SQL;
use warnings;
use strict;

BEGIN {
    $DBIx::DA::Constants::SQL::VERSION = "0.01";
}
use constant SELECT            =>'SELECT';
use constant INSERT            =>'INSERT';
use constant UPDATE            =>'UPDATE';
use constant DELETE            =>'DELETE';
use constant FROM              =>'FROM';
use constant ON                =>'ON';
use constant IN                =>'IN';
use constant NOT_IN            =>'NOT IN';
use constant BETWEEN           =>'BETWEEN';
use constant LIKE              =>'LIKE';
use constant IS_NULL           =>'IS NULL';
use constant NULL              =>'NULL';
use constant IS_NOT_NULL       =>'IS NOT NULL';
use constant AND               =>'AND';
use constant OR                =>'OR';
use constant JOIN              =>'JOIN';
use constant HIERACHICALJOIN   =>'HIERACHICALJOIN';
use constant GROUP_BY          =>'GROUP_BY';
use constant ORDER_BY          =>'ORDER_BY';
use constant GROUPBY          =>'GROUP BY';
use constant ORDERBY          =>'ORDER BY';

use constant WHERE             =>'WHERE';
use constant HAVING            =>'HAVING';
use constant OPEN_PARENS       =>'(';
use constant OPEN_PARENTHESES  => DBIx::DA::Constants::SQL::OPEN_PARENS;
use constant CLOSE_PARENS      =>')';
use constant CLOSE_PARENTHESES => DBIx::DA::Constants::SQL::CLOSE_PARENS;
use constant OPERATION_TYPES   => {
    DBIx::DA::Constants::SQL::SELECT => 1,
    DBIx::DA::Constants::SQL::INSERT => 1,
    DBIx::DA::Constants::SQL::UPDATE => 1,
    DBIx::DA::Constants::SQL::DELETE => 1
};
use constant CLAUSE_TYPES    => DBIx::DA::Constants::SQL::OPERATION_TYPES;
use constant CONDITION_TYPES => {
    DBIx::DA::Constants::SQL::JOIN   => 1,
    DBIx::DA::Constants::SQL::WHERE  => 1,
    DBIx::DA::Constants::SQL::HAVING => 1
};
use constant EXPRESSION => {
   '=' => 1,
   '!='=> 1,
   '<>'=> 1,
   '>' => 1,
   '>='=> 1,
   '<' => 1,
   '<='=> 1,
   '-' => 1,
   '*' => 1,
   '/' => 1,
   '+'=> 1
};
use constant OPERATORS => {
    DBIx::DA::Constants::SQL::IN          => 1,
    DBIx::DA::Constants::SQL::NOT_IN      => 1,
    DBIx::DA::Constants::SQL::BETWEEN     => 1,
    DBIx::DA::Constants::SQL::LIKE        => 1,
    DBIx::DA::Constants::SQL::IS_NULL     => 1,
    DBIx::DA::Constants::SQL::IS_NOT_NULL => 1,
    DBIx::DA::Constants::SQL::AND         => 1,
    DBIx::DA::Constants::SQL::OR          => 1,
    '=' => 1,
   '!='=> 1,
   '<>'=> 1,
   '>' => 1,
   '>='=> 1,
   '<' => 1,
   '<='=> 1,
};

use constant WHERE_CONDITIONS => {
    # DBIx::DA::Constants::SQL::IN          => 1,
    # DBIx::DA::Constants::SQL::NOT_IN      => 1,
    # DBIx::DA::Constants::SQL::BETWEEN     => 1,
    # DBIx::DA::Constants::SQL::LIKE        => 1,
    # DBIx::DA::Constants::SQL::IS_NULL     => 1,
    # DBIx::DA::Constants::SQL::IS_NOT_NULL => 1,
    DBIx::DA::Constants::SQL::AND         => 1,
    DBIx::DA::Constants::SQL::OR          => 1,
     '=' => 1,
   # '!='=> 1,
   # '<>'=> 1,
   # '>' => 1,
   # '>='=> 1,
   # '<' => 1,
   # '<='=> 1,
};
use constant LOGIC => {
    DBIx::DA::Constants::SQL::AND => 1,
    DBIx::DA::Constants::SQL::OR  => 1
};

use constant PARNES => {
    DBIx::DA::Constants::SQL::OPEN_PARENS  => 1,
    DBIx::DA::Constants::SQL::CLOSE_PARENS => 1
};

use constant LEFT_JOIN   =>'LEFT JOIN';
use constant OUTER       =>'OUTER';
use constant LEFT        =>'LEFT';
use constant LEFT_OUTER  =>'LEFT OUTER';
use constant RIGHT_OUTER =>'RIGHT OUTER';
use constant RIGHT       =>'RIGHT';

use constant FULL_OUTER       =>'FULL OUTER';
use constant INNER_JOIN       =>'INNER JOIN';
use constant LEFT_INNER       =>'LEFT INNER';
use constant RIGHT_INNER      =>'RIGHT INNER';
use constant FULL_INNER       =>'FULL INNER';
use constant CONNECT_BY       =>'CONNECT BY';
use constant CONNECT_BY_PRIOR =>'CONNECT BY PRIOR';
use constant START_WITH       =>'START WITH';
use constant JOINS            => {
    DBIx::DA::Constants::SQL::LEFT_JOIN        => 1,
    DBIx::DA::Constants::SQL::RIGHT            => 1,
    DBIx::DA::Constants::SQL::OUTER            => 1,
    DBIx::DA::Constants::SQL::LEFT_OUTER       => 1,
    DBIx::DA::Constants::SQL::RIGHT_OUTER      => 1,
    DBIx::DA::Constants::SQL::FULL_OUTER       => 1,
    DBIx::DA::Constants::SQL::INNER_JOIN       => 1,
    DBIx::DA::Constants::SQL::LEFT_INNER       => 1,
    DBIx::DA::Constants::SQL::RIGHT_INNER      => 1,
    DBIx::DA::Constants::SQL::CONNECT_BY       => 1,
    DBIx::DA::Constants::SQL::CONNECT_BY_PRIOR => 1,
    DBIx::DA::Constants::SQL::START_WITH       => 1,
};
use constant AVG    =>'AVG';
use constant COUNT  =>'COUNT';
use constant FIRST  =>'FIRST';
use constant LAST   =>'LAST';
use constant MAX    =>'MAX';
use constant MIN    =>'MIN';
use constant SUM    =>'SUM';
use constant CONCAT =>'CONCAT';
use constant AS     =>'AS';


use constant REQUIRED =>'R';
use constant OPTIONAL =>'O';
use constant NOW      =>'sysdate';

use constant AGGREGATES => {
    DBIx::DA::Constants::SQL::AVG   => 1,
    DBIx::DA::Constants::SQL::COUNT => 1,
    DBIx::DA::Constants::SQL::FIRST => 1,
    DBIx::DA::Constants::SQL::LAST  => 1,
    DBIx::DA::Constants::SQL::MAX   => 1,
    DBIx::DA::Constants::SQL::MIN   => 1,
    DBIx::DA::Constants::SQL::SUM   => 1,
};

use constant FUNCTIONS => {
    DBIx::DA::Constants::SQL::CONCAT => {
        DBIx::DA::Constants::SQL::REQUIRED => 2,
        DBIx::DA::Constants::SQL::OPTIONAL => 0
    },
};

use constant ASC      =>'ASC';
use constant DESC     =>'DESC';
use constant ORDER => {
    DBIx::DA::Constants::SQL::ASC  => 1,
    DBIx::DA::Constants::SQL::DESC => 1,
};

use constant CLAUSES => {
    DBIx::DA::Constants::SQL::JOIN => 1,
    DBIx::DA::Constants::SQL::HIERACHICALJOIN => 1,
    DBIx::DA::Constants::SQL::GROUP_BY        => 1,
    DBIx::DA::Constants::SQL::HAVING          => 1,
    DBIx::DA::Constants::SQL::ORDER_BY        => 1,
    DBIx::DA::Constants::SQL::WHERE           => 1,#not really an object
};


# use constant CLAUSES => {
    # "DBIx::DA::Join"            => 1,
    # "DBIx::DA::HierachicalJoin" => 1,
    # "DBIx::DA::Group_by"        => 1,
    # "DBIx::DA::Having"          => 1,
    # "DBIx::DA::OrderBy"         => 1,
    # "DBIx::DA::Where"           => 1,#not really an object
# };




1;