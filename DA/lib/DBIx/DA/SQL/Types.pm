package DBIx::DA::SQL::Types;
use lib qw( E:\chemstore_m\DA-0.01\lib);
use Data::Dumper;
use Moose::Role;
use Moose::Util::TypeConstraints;

use namespace::autoclean;
use DBIx::DA::Constants::SQL;
use DBIx::DA::Table;
use DBIx::DA::Field;
use DBIx::DA::OrderByField;
use DBIx::DA::OrderByParam;
#use DBIx::DA::GroupByField;
use DBIx::DA::SelectField;
use DBIx::DA::Function;
use DBIx::DA::Join;
use DBIx::DA::Where;
#use DBIx::DA::Static;
#use DBIx::DA::Predicate;
use DBIx::DA::Expression;
use DBIx::DA::Join::Predicate;
use DBIx::DA::Where::Predicate;
use DBIx::DA::Param;

class_type 'Where',      { class => 'DBIx::DA::Where' };
class_type 'Param',      { class => 'DBIx::DA::Param' };
class_type 'Table',      { class => 'DBIx::DA::Table' };
class_type 'Field',      { class => 'DBIx::DA::Field' };
class_type 'OrderByField',{ class => 'DBIx::DA::OrderByField' };
#class_type 'GroupByField',{ class => 'DBIx::DA::GroupByField' };
class_type 'SelectField',{ class => 'DBIx::DA::SelectField' };
class_type 'Function',   { class => 'DBIx::DA::Function' };
class_type 'Join',       { class => 'DBIx::DA::Join' };
#class_type 'Static',     { class => 'DBIx::DA::Static' };

class_type 'JoinPredicate',   { class => 'DBIx::DA::Join::Predicate' };
class_type 'WherePredicate',   { class => 'DBIx::DA::Where::Predicate' };
class_type 'Expression',   { class => 'DBIx::DA::Expression' };
class_type 'OrderByParam',   { class => 'DBIx::DA::OrderByParam' };

subtype 'SQLExpression',
as 'Str',
  where { exists( DBIx::DA::Constants::SQL::EXPRESSION->{ uc($_) } ) },
  message { "The Expression '$_', is not a valid SQLExpression!"._try_one_of(DBIx::DA::Constants::SQL::EXPRESSION()) };


subtype 'SQLName',
  as 'Str',
  where { if (index($_,' ') == -1 ) {return 1}} ,
  message { "The Name '$_', is not a valid Table, Join or Field name! "};


subtype 'SQLAggregate',
  as 'Str',
  where { exists( DBIx::DA::Constants::SQL::AGGREGATES->{ uc($_) } ) },
  message { "The Aggrerate '$_', is not a valid SQLAggregate!"._try_one_of(DBIx::DA::Constants::SQL::AGGREGATES()) };


subtype 'SQLOrder',
  as 'Str',
  where { exists( DBIx::DA::Constants::SQL::ORDER->{ uc($_) } ) },
  message { "The Order '$_', is not a valid SQL Order!"._try_one_of(DBIx::DA::Constants::SQL::ORDER()) };

subtype 'SQLFunction',
  as 'Str',
  where { exists( DBIx::DA::Constants::SQL::FUNCTIONS->{ uc($_) } ) },
  message { "The Function '$_', is not a valid SQL Function!"._try_one_of(DBIx::DA::Constants::SQL::FUNCTIONS()) };

subtype 'SQLJoin',
  as 'Str',
  where { exists( DBIx::DA::Constants::SQL::JOINS->{ uc($_) } ) },
  message { "The Join Clause '$_', is not a valid SQL Join Clause!"._try_one_of(DBIx::DA::Constants::SQL::JOINS()) };

subtype 'SQLOperator',
  as 'Str',
  where { exists( DBIx::DA::Constants::SQL::OPERATORS->{ uc($_) } ) },
  message { "The Operator '$_', is not a valid SQL Operator!"._try_one_of(DBIx::DA::Constants::SQL::OPERATORS()) };

subtype 'WhereCondition',
  as 'Str',
  where { exists( DBIx::DA::Constants::SQL::WHERE_CONDITIONS->{ uc($_) } ) },
  message { "The Condition Operator '$_', is not a valid between Where conditions!"._try_one_of(DBIx::DA::Constants::SQL::WHERE_CONDITIONS()) };

subtype 'SQLClause',
  as 'Str',
  where { exists( DBIx::DA::Constants::SQL::CLAUSES->{ uc($_)  } ) },
  message { "The Clause Type '" .$_ . "', is not a valid SQL Clause!"._try_one_of(DBIx::DA::Constants::SQL::CLAUSES())  };

subtype 'ArrayRefOfFunctionOptions' => as 'ArrayRef[Field|Param|Function]';
subtype 'ArrayRefofFields'          => as 'ArrayRef[Field]';
subtype 'ArrayRefofOrderByFields'   => as 'ArrayRef[OrderByField|OrderByParam]';
#subtype 'ArrayRefofGroupByFields'   => as 'ArrayRef[GroupByField]';
subtype 'ArrayRefofSelectFields'   => as 'ArrayRef[SelectField|Expression|Function]';
subtype 'ArrayRefofFunctions'   => as 'ArrayRef[Function]';

subtype 'ArrayRefofJoins'           => as 'ArrayRef[Join]';
subtype 'ArrayRefofWheres'          => as 'ArrayRef[Where]';


subtype 'ArrayRefofPredicates'      => as 'ArrayRef[Predicate]';
subtype 'ArrayRefofJoinPredicates'  => as 'ArrayRef[JoinPredicate]';
subtype 'ArrayRefofWherePredicates' => as 'ArrayRef[WherePredicate]';
subtype 'ArrayRefofParams'          => as 'ArrayRef[Param]';

coerce 'Table', from 'HashRef', via { DBIx::DA::Table->new( %{$_} ) };


coerce 'Field', from 'HashRef', via { 
     

        if ( exists( $_->{function} ) ) {
            
           
            return DBIx::DA::SelectField->new({ name=>exists($_->{name})?$_->{name}:$_->{field}->{name},
                                                            expression=>DBIx::DA::Function->new( $_) } );
        }
        elsif ( exists( $_->{expression} ) ) {
            
           
            return DBIx::DA::SelectField->new({ name=>exists($_->{name})?$_->{name}:$_->{field}->{name},
                                                            expression=>DBIx::DA::Expression->new( $_) } );
        }
        elsif ( exists( $_->{param} ) ) {
                #warn("Field from hash ref = ".Dumper($_->{param} ));       
            return DBIx::DA::Param->new($_);
        }
         DBIx::DA::Field->new( %{$_} ) },
      from 'Str', via { #warn("Field from STR = ".Dumper($_)); 
            DBIx::DA::Param->new({value=>$_}) };



# coerce 'Where', from 'HashRef', via { DBIx::DA::Where->new( %{$_} ) };


# coerce 'ArrayRefofFields', from 'ArrayRef', via {
    # [ map { DBIx::DA::Field->new($_) } @$_ ];
# };
coerce 'ArrayRefofOrderByFields', from 'ArrayRef', via {
    
    
    return  _object_expression("DBIx::DA::OrderByField",\@$_,{"DBIx::DA::OrderByField"=>1,"DBIx::DA::OrderByParam"=>1});

};

coerce 'ArrayRefofFields', from 'ArrayRef', via {
    
   return  _array_or_object("DBIx::DA::Field",\@$_);
   
};


coerce 'ArrayRefofSelectFields', from 'ArrayRef', via {
     my $objects;
     
    # warn("ArrayRefofSelectFields".Dumper(\@$_));
     foreach my $object (@$_) {
        if ( exists( $object->{function} ) ) {
            
            ##warn("function ".Dumper($object));
            
            push( @{$objects},  DBIx::DA::SelectField->new({ name=>exists($object->{name})?$object->{name}:$object->{field}->{name},
                                                            expression=>DBIx::DA::Function->new( $object) } ));
        }
        elsif ( exists( $object->{expression} ) ) {
            push( @{$objects},  DBIx::DA::Expression->new( $object) );
        }
        else {
            push( @{$objects}, DBIx::DA::SelectField->new( $object ) );
        }
    }
    return $objects;
 

};

sub _object_expression {
      my ($class,$in,$allowed) = @_;
     my $objects;
     
       
   #  warn("_object_expression".Dumper(\@$_));
     foreach my $object (@$_) {
         
            
        if (exists($allowed->{ref($object)})) {
           push( @{$objects}, $object);
        }
        elsif ( exists( $object->{function} ) ) {
            
          
            
            push( @{$objects},  $class->new({ name=>exists($object->{name})?$object->{name}:$object->{field}->{name},
                                                            expression=>DBIx::DA::Function->new( $object) } ));
        }
        elsif ( exists( $object->{expression} ) ) {
            push( @{$objects},  $class->new( $object) );
        }
        elsif ( exists( $object->{param}) and $class eq "DBIx::DA::OrderByField" ){
            warn("object=".Dumper($object));
                push(@{$objects},DBIx::DA::OrderByParam->new( $object));
        }
        else {
            push( @{$objects}, $class->new( $object ) );
        }
    }
    return $objects;
 

};

coerce 'ArrayRefofFunctions', from 'ArrayRef', via {
    
#  #warn("ArrayRefofFunctions".Dumper(\@$_));
    return  _array_or_object("DBIx::DA::Function",\@$_);
 };
 # from 'HashRef', via {
     # return DBIx::DA::Function->new( %{$_} );
 # };
 
 
 
sub _array_or_object {
    my ($class,$in) = @_;
    
      #warn("_array_or_object $class ".Dumper($in));
    
     my $objects;
    foreach my $object (@$_) {
        if ( ref( $object) eq $class ) {
            push( @{$objects},  $object );
        }
        else {
            push( @{$objects},$class->new( $object ) );
        }
    }
    return $objects;
    
     
}

coerce 'ArrayRefofParams', from 'ArrayRef', via {
    #warn("ArrayRefofParams here ".Dumper(\@$_));
    
    return DBIx::DA::Param->new({value=>\@$_});
    
    [ map { DBIx::DA::Param->new({value=>$_}) } @$_ ],
    
    
};


# coerce 'Function', from 'HashRef', via { 
      ##warn('where Function = '.Dumper(\$_));
     
    # DBIx::DA::Function->new( %{$_} ) 
    
    # };

coerce 'ArrayRefOfFunctionOptions', from 'ArrayRef', via {
    my $objects;
  #  warn("ArrayRefOfFunctionOptions  ".Dumper(\@$_));
    
    foreach my $object (@$_) {
        
        if (ref($object) ne "HASH") {
            
          push( @{$objects}, DBIx::DA::Param->new({value=>$object}))
          
        }
        elsif ( exists( $object->{function} ) ) {
            push( @{$objects}, DBIx::DA::Function->new( $object ) );
        }
        elsif ( exists( $object->{field} ) ) {
            push( @{$objects}, DBIx::DA::Field->new( $object->{field} ) );
        }
        elsif ( exists( $object->{on} ) ) {
            push( @{$objects}, DBIx::DA::Field->new( $object->{on} ) );
        }
        
        else {
            
            push( @{$objects}, DBIx::DA::Param->new( ref($object->{param}) eq "HASH"?$object->{param}:{value=>$object->{param}} ) );
        }
    }
    return $objects;
};


coerce 'ArrayRefofJoins', from 'ArrayRef', via {
    my $da;
    my $objects;
    foreach my $object (@$_) {
        if ( ref($object) eq "DBIx::DA::Join" ) {
            push( @{$objects}, $object );
            $da = $object->DA();
        }
        else {
            $object->{DA} = $da
              if ( ref($da) eq 'DBIx::DA::SQL' );
            push( @{$objects}, DBIx::DA::Join->new($object) );
        }
    }
    return $objects;
};

coerce 'ArrayRefofWheres', from 'ArrayRef', via {
 
    my $da;
    my $objects;
    foreach my $object (@$_) {
        if ( ref($object) eq "DBIx::DA::Where" ) {
            push( @{$objects}, $object );
            $da = $object->DA();
        }
        else {
            $object->{DA} = $da
              if ( ref($da) eq 'DBIx::DA::SQL' );
              # $object->{condition} = DBIx::DA::Constants::SQL::AND
                # unless(exists($object->{operator}));
            #   #warn("just befor");
            push( @{$objects}, DBIx::DA::Where->new({predicates=>[$object]}) );
        }
    }
    return $objects},
    from 'HashRef', via {
    
    
    
    
    my $da;
    my $objects;
    foreach my $object (@$_) {
        if ( ref($object) eq "DBIx::DA::Where" ) {
            push( @{$objects}, $object );
            $da = $object->DA();
        }
        else {
            $object->{DA} = $da
              if ( ref($da) eq 'DBIx::DA::SQL' );
              # $object->{operator} = DBIx::DA::Constants::SQL::AND
                # unless(exists($object->{operator}));
            push( @{$objects}, DBIx::DA::Where->new({predicates=>[$object]}) );
        }
    }
    return $objects;
};


coerce 'ArrayRefofJoinPredicates', from 'ArrayRef', via {
    [ map { DBIx::DA::Join::Predicate->new($_) } @$_ ];
};

coerce 'ArrayRefofWherePredicates', from 'ArrayRef', via {
  # warn("ArrayRefofWherePredicates".Dumper($_));
   # my $objects;
    # foreach my $object (@$_) {
          # #warn("object  ".Dumper($object));
        # if ( exists( $object->{function} ) ) {
            # push( @{$objects}, DBIx::DA::Function->new( $object ) );
        # }
        # elsif ( exists( $object->{field} ) ) {
            # push( @{$objects}, DBIx::DA::Field->new( $object->{field} ) );
        # }
        # elsif ( exists( $object->{on} ) ) {
            # push( @{$objects}, DBIx::DA::Field->new( $object->{on} ) );
        # }
        
        # else {
            # push( @{$objects}, DBIx::DA::Param->new( ref($object->{param}) eq "HASH"?$object->{param}:{value=>$object->{param}} ) );
        # }
    # }
    # return $objects;
   
    [ map {DBIx::DA::Where::Predicate->new($_) } @$_ ]};
    # from 'HashRef', via {
      # [DBIx::DA::Where::Predicate->new($_)]  
    # }
 # };

sub _try_one_of {
    my ($hash) = @_;
    return " Try one of '".join("', '",keys(%{$hash}))."'";     
}
1;
