package DBIx::DA::SQL;

BEGIN {
    $DBIx::DA::SQL::VERSION = "0.01";
}
use lib qw( d:\GitHub\DataAccessor_moose\Da-Moose\DA\lib);

#use lib qw(C:\Users\John Scoles\Dropbox\Code_Base\chemstore_perl_05_19\Orignal\Orignal\lib\DA);
use DBI;
use Carp();
use Data::Dumper;
use DBIx::DA::Constants::SQL;
use DBIx::DA::Constants::DA;
use Moose;
use MooseX::Aliases;
with qw(DBIx::DA DBIx::DA::SQL::Types);

sub BUILD {

    my ( $self, $params ) = @_;

    foreach my $join ( @{ $self->joins() } ) {
        $join->DA($self);

        foreach my $predicate ( @{ $join->predicates() } ) {
            $predicate->clause($self);

            # $predicate->right->DA($self);
            $predicate->right->table( $join->to_table() )
              unless ( $predicate->right->table() );
        }

    }

    foreach my $where ( @{ $self->where(), $self->having() } ) {
        $where->DA($self);

        foreach my $predicate ( @{ $where->predicates() } ) {
            $predicate->clause($self);

            $predicate->left->table( $self->table()->name() )
              if ( $predicate->left->can("table")
                and !$predicate->left->table() );

            if ( ref( $predicate->right ) eq "ARRAY" ) {
                foreach my $in_predicate ( @{ $predicate->right } ) {
                    $in_predicate->table( $self->table()->name() )
                      if ( $in_predicate->can("table")
                        and !$in_predicate->table() );
                }
            }
            else {
                $predicate->right->table( $self->table()->name() )
                  if ( $predicate->right->can("table")
                    and !$predicate->right->table() );
            }
        }
    }

}

has table => (
    is     => 'rw',
    isa    => 'Table',
    coerce => 1,
);

has fields => (
    traits  => ['Array'],
    is      => 'ro',
    isa     => 'ArrayRefofSelectFields',
    coerce  => 1,
    handles => { count_fields => 'count',
                 find_field=>'first',
     }
);

has joins => (
    traits  => ['Array'],
    is      => 'ro',
    isa     => 'ArrayRefofJoins',
    coerce  => 1,
    default => sub { [] },
    handles => {

        # add_join  => 'push',
        count_join => 'count',
      }

);

has where => (
    traits  => ['Array'],
    is      => 'ro',
    isa     => 'ArrayRefofWheres',
    coerce  => 1,
    default => sub { [] },
    handles => { count_where => 'count', },

);
has having => (
    traits  => ['Array'],
    is      => 'ro',
    isa     => 'ArrayRefofWheres',
    coerce  => 1,
    default => sub { [] },
    handles => { count_having => 'count', },

);

has group_by => (
    traits  => ['Array'],
    is      => 'ro',
    isa     => 'ArrayRefofFields',
    coerce  => 1,
    default => sub { [] },
    handles => { count_group_by => 'count', }
);

has order_by => (
    traits  => ['Array'],
    is      => 'ro',
    isa     => 'ArrayRefofOrderByFields',
    coerce  => 1,
    default => sub { [] },
    handles => {
        count_order_by => 'count',
        clear_order_by => 'clear'
    }
);

has dynamic_fields => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'ArrayRefofSelectFields',
    coerce  => 1,
    default => sub { [] },
    handles => {
        add_field            => 'push',
        count_dynamic_fields => 'count',
    }
);

has dynamic_joins => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'ArrayRefofJoins',
    coerce  => 1,
    default => sub { [] },
    handles => {
        add_join           => 'push',
        count_dynamic_join => 'count',
      }

);

has dynamic_where => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'ArrayRefofWheres',    #'ArrayRefofDynamicWheres',
    coerce  => 1,
    default => sub { [] },
    handles => {
        add_where           => 'push',
        count_dynamic_where => 'count',
      }

);

has dynamic_having => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'ArrayRefofWheres',
    coerce  => 1,
    default => sub { [] },
    handles => {
        add_having           => 'push',
        count_dynamic_having => 'count',
    },

);

has dynamic_group_by => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'ArrayRefofFields',
    coerce  => 1,
    default => sub { [] },
    handles => {
        add_group_by           => 'push',
        count_dynamic_group_by => 'count',
        clear_dynamic_group_by => 'clear'
      }

);

has dynamic_order_by => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'ArrayRefofOrderByFields',
    coerce  => 1,
    default => sub { [] },
    handles => {
        add_order_by           => 'push',
        count_dynamic_order_by => 'count',
        clear_dynamic_order_by => 'clear'
      }

);

foreach my $clauses (
    qw(where dynamic_where joins dynamic_joins having dynamic_having))
{

    around $clauses => sub {
        my $orig = shift;
        my $self = shift;

        # my $thing = $self->$orig()->[0];

        foreach my $thingy ( @{ $self->$orig() } ) {

            # #warn( "self $thingy=" . Dumper($thingy) );
            $thingy->DA($self);
            foreach my $predicate ( @{ $thingy->predicates() } ) {

                # #warn( "predeicate " . Dumper($predicate) );
                $predicate->clause($thingy);

                $predicate->left->table( $thingy->DA->table()->name() )
                  if ( $predicate->left->can("table")
                    and !$predicate->left->table() );

                if ( ref( $predicate->right ) eq "ARRAY" ) {
                    foreach my $in_predicate ( @{ $predicate->right } ) {
                        $in_predicate->table( $thingy->DA->table()->name() )
                          if ( $in_predicate->can("table")
                            and !$in_predicate->table() );
                    }
                }
                else {
                    $predicate->right->table( $thingy->DA->table()->name() )
                      if ( $predicate->right->can("table")
                        and !$predicate->right->table() );
                }
            }
        }
        return $self->$orig();

    };
}

has _params => (
    traits  => ['Array'],
    is      => 'rw',
    isa     => 'ArrayRefofParams',    #ofPredicates',
    default => sub { [] },
    handles => {
        _add_param    => 'push',
        _count_params => 'count',
        _clear_params => 'clear'
      }

);
has _parens_are_open => (
    traits  => ['Counter'],
    is      => 'rw',
    default => 0,
    isa     => 'Int',
    handles => {
        _inc_parens   => 'inc',
        _dec_parens   => 'dec',
        _reset_parens => 'reset'
    }
);

has [
    qw(distinct
      static_sql

      returning
      type
      use_field_alias
      )
] => ( is => 'rw', isa => 'Str|Undef' );

has [
    qw(initialized
      use_named_params
      use_field_alias
      )
] => ( is => 'rw', isa => 'Bool|Undef' );

has [
    qw( rows_effected

      )
] => ( is => 'rw', isa => 'Int|Undef' );

# has [
# qw(

# hierarchical_joins

# only_fields

# )
# ] => ( is => 'rw', isa => 'ArrayRef|Undef' );

has [
    qw(_field_named
      )
] => ( is => 'rw', isa => 'HashRef|Undef' );

sub initialize {
    my $self = shift;

    ##warn("SQL initalize/n");
    $self->fields( [] );
    $self->joins(  [] );
    $self->_field_named( {} );
    $self->reset();
    $self->_initialized(1);
}

sub reset {
    my $self = shift;

    ##warn("SQL reset/n");
    $self->predicates(         [] );
    $self->dynamic_joins(      [] );
    $self->dynamic_predicates( [] );

    #$self->order_bys(          [] );
    $self->only_fields( [] );
    $self->expire_cache();
}

sub _identity_keys {
    my $self = shift;
    my @keys = ();
    foreach my $field ( $self->fields ) {

        ##warn(Dumper($field));
        if ( $field->is_identity() || $field->is_unique() ) {
            my $name = $field->name();
            if ( $field->alias() ) {
                $name = $field->alias();
            }
            push( @keys, $name );
        }
    }
    return @keys;
}

sub _execute {
    my $self = shift;
    my ( $dbh, $container, $opts ) = @_;
    my $exe_array = 0;
    $self->results( [] );
    $self->_clear_params();

# #warn("\n\n\n ".$self." Execute start ");
# #warn(" dbh=".$dbh.", continer=".$container."\n");
# #
#   #warn("I Start with >dynamic_predicate = ".Dumper($self->dynamic_predicates));
# #warn("I Start with predicate = ".Dumper($self->predicates));
# #warn("I Start with joins = ".Dumper($self->joins));
# #warn("I Start with dynamic_joins = ".Dumper($self->dynamic_joins));
#

    $dbh = $self->_connect()
      unless ($dbh);

    my $sql;

    if ( $self->static_sql() ) {
        $sql = $self->static();
    }
    elsif ( $self->_operation eq DBIx::DA::Constants::DA::CREATE ) {
        $sql = $self->_insert($container);
    }
    elsif ( $self->_operation eq DBIx::DA::Constants::DA::UPDATE ) {
        $sql = $self->_update($container);
    }
    elsif ( $self->_operation eq DBIx::DA::Constants::DA::DELETE ) {
        $sql = $self->_delete();
    }
    else {
        $sql = $self->_select_clause();
    }

    ##warn("my SQL qa =".$sql."\n");

    my $sth;

    ##warn("my $dbh =".$dbh."\n");

    eval {

        $sth = $dbh->prepare($sql);
    };
    if ($@) {

        #warn( "error=" . $@ );
    }
    my @params;    # = $self->_params();

    foreach my $param ( @{ $self->_params() } ) {
        my $value = $param->value();

        if ( $value and $value->isa("DBIx::DA::SQL") ) {
            foreach my $nested ( $value->_params ) {    #this needs to recurse
                push( @params, $nested );
            }
        }
        else {
            push( @params, $param );
        }
    }
    my $param_count = scalar(@params);

    #    #warn( "Params = " . Dumper( \@params ) );

    for ( my $count = 1 ; $count <= $param_count ; $count++ ) {
        my $param = shift(@params);
        my $value = $param->value();

        my %type = ();

        if ( $param->type ) {
            $type{type} = $param->type();
        }

        # #warn("bind value=$value \n");

        #
        if ( ref($value) eq 'ARRAY' ) {
            $sth->bind_param_array( $count, $value, %type );
            $exe_array = 1;

            #warn( "bind value=" . ref($value) . "\n" );
        }
        else {
            if ( $self->use_named_params ) {
                $sth->bind_param( ":p_" . $param->name(), $value, %type );
            }
            else {
                $sth->bind_param( $count, $value, %type );
            }
        }
    }
    my @returns = undef;

    if (    ( $self->returning() )
        and ( $self->_operation() ne DBIx::DA::Constants::DA::RETRIEVE ) )
    {
        my @params       = $self->returning()->params();
        my $return_count = scalar(@params);
        @returns = ( 1 .. $return_count );
        for ( my $count = 1 ; $count <= $return_count ; $count++ ) {
            my $param = shift(@params);
            my %type  = ();
            if ( $param->type ) {
                $type{type} = $param->type();
            }
            if ( $self->use_named_params ) {
                $sth->bind_param_inout(
                    ":p_" . $param->name(),
                    \$returns[ $count - 1 ],
                    '100', %type
                );
            }
            else {
                $sth->bind_param_inout(
                    $count + $param_count,
                    \$returns[ $count - 1 ],
                    '100', %type
                );
            }

        }
    }
    if ( $self->_operation() eq DBIx::DA::Constants::DA::RETRIEVE ) {

        #warn("JPS exe");
        $sth->execute();

        # #warn("JPS exe2 container=".ref($container));

        $container = []
          if ( !$container );

        if ( ref($container) eq 'ARRAY' ) {
            my $results = $sth->fetchall_arrayref();

            #  push(@{$container},@{$results});
            $self->results($results);
        }
        elsif ( ref($container) eq "HASH" or $container->isa("UNIVERSAL") ) {
            my @key_fields = $self->_identity_keys()
              ;    #(ref $key_field) ? @$key_field : ($key_field);
            if ( !scalar(@key_fields) ) {
                die
"error: DBIx::DA:::SQL->execute attempt to use a HASH Ref as container without a DBIx::DA::Field without an is_identity attribute!";
            }
            my $hash_key_name = $sth->{FetchHashKeyName} || 'NAME_lc';
            if ( $hash_key_name eq 'NAME' or $hash_key_name eq 'NAME_uc' ) {
                @key_fields = map( uc($_), @key_fields );
            }
            else {
                @key_fields = map( lc($_), @key_fields );
            }
            my $names_hash = $sth->FETCH("${hash_key_name}_hash");
            my @key_indexes;
            my $num_of_fields = $sth->FETCH('NUM_OF_FIELDS');
            foreach (@key_fields) {

                my $index = $names_hash->{$_};    # perl index not column
                $index = $_ - 1
                  if !defined $index
                      && DBI::looks_like_number($_)
                      && $_ >= 1
                      && $_ <= $num_of_fields;
                return $sth->set_err( $DBI::stderr,
"Field '$_' does not exist (not one of @{[keys %$names_hash]})"
                ) unless defined $index;
                push @key_indexes, $index;
            }
            my $NAME = $sth->FETCH($hash_key_name);
            my @row  = (undef) x $num_of_fields;
            $sth->bind_columns( \(@row) );

            while ( $sth->fetch ) {

                if ( ref($container) eq "HASH" ) {
                    my $ref = $container;    #();#$rows;
                    $ref = $ref->{ $row[$_] } ||= {} for @key_indexes;
                    @{$ref}{@$NAME} = @row;
                    $self->push_results($ref);
                }
                else {
                    my $new_item = $container->new();

                    ##warn(ref($container));
                    foreach my $key ( keys( %{$names_hash} ) ) {

                        $new_item->$key( $row[ $names_hash->{$key} ] )
                          if ( $new_item->can($key) );

                        # #$ref = $ref->$row[$_]} ||= {} for @key_indexes;
                    }

                    $new_item = {%$new_item}
                      if ( $opts->{CLASS_AS_HASH} );

                    $self->push_results($new_item);

                }

            }

        }
    }
    else {
        if ($exe_array) {

            ##warn("exe array here\n");
            my @tuple_status;

            my $tuples =
              $sth->execute_array( { ArrayTupleStatus => \@tuple_status } );

            $self->rows_effected( scalar($tuples) );

        }
        else {
            my $rows_effected = $sth->execute();
            $self->rows_effected($rows_effected);
            if (@returns) {
                $self->push_results( \@returns );
            }

        }
        $dbh->commit();
    }

    $dbh->{dbd_verbose} = 0;

##warn("end SQL iam a ".ref($self));
# #warn("In I  have ".ref($self)." predicate = ".scalar($self->dynamic_predicates));
# $self->dynamic_joins([]);
# $self->dynamic_predicates([]);
# #warn("Out I  have predicate = ".$self->dynamic_predicates);
#
}

# sub empty_fields {
# my $self = shift;
# $self->fields( [] );
# $self->_field_named( {} );

# }

# sub empty {
# my $self = shift;

# $self->distinct("");
# $self->table(undef);
# $self->fields( [] );
# $self->_field_named( {} );
# $self->joins(      [] );
# $self->predicates( [] );

# $self->group_by(undef);
# $self->having(undef);
# $self->order_bys( [] );
# }

# sub _field_exists {
# my $self = shift;
# my ($field) = @_;

# my $current_index = $self->values__field_named();

# my $field_name = $field->name();

# $field_name = $field->alias()
# if ( $field->alias() );

# #my $table_name    = $field->table_name();

# # if ($table){
# # if ($$table->alias()){
# # $table_name = $$table->alias()
# # }
# # else {
# # $table_name = $$table->name();
# # }
# # $table_name.='.';
# # }
# # $field_name= $table_name.".".$field_name;
# #   ##warn("table_name=".$table_name."\n");
# ##warn("field_name=".$field_name."\n");
# if ( $field->alias() ) {
# if ( $self->exists__field_named($field_name) ) {
# die(    "ERROR:"
# . ($self)
# . ", field with alias="
# . $field_name
# . " is already defined!" );
# }
# }
# else {
# if ( $self->exists__field_named($field_name) ) {
# die(    "ERROR:"
# . ($self)
# . ", field with name="
# . $field_name
# . " is already defined! Try using an alias!" );
# }
# }
# $self->_field_named( { $field_name => $current_index } );
# }

# sub field_value {
# my $self = shift;
# my ($field_name) = @_;

# ##warn("1 in field_named=".$field_name."\n");
# # my $table_name   = "";
# # $table_name      = $self->table()->name()
# # if ($self->table->name());
# # $table_name      = $self->table()->alias()
# # if ($self->table->alias());
# #
# # $field_name= $table_name.".".$field_name
# # if ($table_name);
# # #warn("field_named=".$field_name."\n");
# if ( $self->exists__field_named($field_name) ) {
# my %field = $self->_field_named($field_name);

# ##warn("field_named=".$field{$field_name}."\n");
# my @fields = $self->fields();
# return $fields[ $field{$field_name} ]->value();
# }
# else {
# return undef;
# }
# }

sub _only_fields {

    my $self = shift;

    my @fields;
    foreach my $show_field ( $self->only_fields() ) {

        push( @fields, $self->field_named($show_field) );
    }

    return @fields;
}

sub set_field_values {
    my $self = shift;
    my ($opt) = @_;

    ref($opt) eq 'ARRAY'
      || die("ERROR: QuerySQL::set_field_values, must be an array of hashes.");

    foreach my $field ( @{$opt} ) {

        my $new_value = $self->field_named( $field->{name} );
        die(    "ERROR: " 
              . $self
              . "::set_field_values, field='"
              . $field->{name}
              . "' not found in "
              . ref($opt) )
          unless ($new_value);
        next
          if ( $new_value->is_identity() );

        $new_value->value( $field->{value} );

    }

}

sub sql {
    my $self = shift;
    $self->_params(   [] );
    $self->returning( [] );
    my $sql = "";
    $sql = $self->_insert()
      if ( $self->_operation() eq DBIx::DA::Constants::DA::CREATE );
    $sql = $self->_select_clause()
      if ( $self->_operation() eq DBIx::DA::Constants::DA::RETRIEVE );
    $sql = $self->_update()
      if ( $self->_operation() eq DBIx::DA::Constants::DA::UPDATE );
    $sql = $self->_delete()
      if ( $self->_operation() eq DBIx::DA::Constants::DA::DELETE );

    # $sql .= $self->_from_clause()."\n";
    # $sql .= $self->_join_clause()."\n";
    # $sql .= $self->_where_clause()."\n";
    # $sql .= $self->_group_by_clause()."\n";
    # $sql .= $self->_having_clause()."\n";
    # $sql .= $self->_order_by_clause()."\n";
    return $sql;
}

sub _update {
    my $self        = shift;
    my ($container) = @_;
    my $delimiter   = "";
    my $expressions = "";
    $self->_params( [] );
    my @fields_to_change = $self->fields();
    if ($container) {
        @fields_to_change = ();

        foreach my $key ( keys( %{$container} ) ) {

            my $field = $self->field_named($key);
            next
              unless $field;
            $field->value( $container->{$key} );
            push( @fields_to_change, $field );
        }
    }

    foreach my $field (@fields_to_change) {
        unless ( $field->no_update() or $field->is_identity() ) {
            $expressions .= $delimiter . $field->name() . " = ";
            if ( $field->value() eq 'sysdate' ) {
                $expressions .= "sysdate";
            }
            else {
                $self->push__params($field);

                if ( $self->use_named_params() ) {
                    $expressions .= " :p_" . $field->name();
                }
                else {
                    $expressions .= " ? ";
                }
            }
            $delimiter = ", ";
        }
    }

    my $sql =
        DBIx::DA::Constants::SQL::UPDATE . " "
      . $self->table->name() . " SET "
      . $expressions;

    # if ($self->joins()){
    # $sql.=$self->_join_clause();
    # }
    ##warn("where clause next");
    if ( $self->predicates() || $self->dynamic_predicates() ) {

        $sql .= $self->_where_clause( DBIx::DA::Constants::SQL::WHERE, ) . "\n";
    }
    elsif ( !$self->can_global_update() ) {
        die(
"ERROR: QuerySQL::upadate, Attempt to Update on a table without a 'where' clause when enable_global_update is not enabled!"
        );
    }
    if ( $self->returning() ) {
        $sql .= $self->_returning_clause();
    }
    return $sql;
}

sub _delete {
    my $self = shift;

    my $sql = DBIx::DA::Constants::SQL::DELETE . " " . $self->table->name();

    if ( $self->predicates() || $self->dynamic_predicates() ) {
        $sql .= $self->_where_clause() . "\n";
    }
    elsif ( !$self->can_global_delete() ) {
        die(
"ERROR: QuerySQL::delete, Attempt to Delete on a table without a 'where' clause when enable_global_delete is not enabled!"
        );
    }
    if ( $self->returning() ) {
        $sql .= $self->_returning_clause();
    }

    ##warn("Delete sql=".$sql);
    return $sql;
}
    
sub _insert_clause {
    my $self             = shift;
    my ($container)      = @_;
    my $delimiter        = "";
    my $field_clause     = "";
    my $value_clause        = "";
    my @fields_to_insert = $self->fields();
    my $sql =
      DBIx::DA::Constants::SQL::INSERT . " INTO " . $self->table()->name();

    #$container->isa();

    if ( ref($container) eq "DBIx::DA::SQL" ) {    #insert with select
        foreach my $field  ( $self->fields ) {
           
           next
             if (($field->table() and $field->table() ne $self->table()->name())
                  or ($field->no_insert() or $field->expression()));
                  
            $field_clause  .= $delimiter . $field->name();
            $delimiter = ", ";
        }
        $sql .= " (" . $field_clause . " ) " . $container->_select_clause();

        foreach my $sub_param ( @{$container->_params()} ) {
            $self->add_params($sub_param);
        }
    }
    else {

        @fields_to_insert = ();

        foreach my $key ( keys( %{$container} ) ) {

            my $field = $self->find_field(sub {$_->name eq $key});
            next
              unless $field;
            next 
              if $field->no_insert();
            use Data::Dumper;
            $field_clause .= $delimiter . $field->name();
            if ( $field->is_identity() and $field->sequence() ) {
                    $value_clause .= $field->sequence() . ".nextval";
                    $self->returning(
                        DBIx::DA::Returning->new(
                            {
                                params => [
                                    DBIx::DA::Param->new(
                                        {
                                            name  => $field->name(),
                                            value => \$field
                                        }
                                    )
                                ]
                            }
                        )
                    );
             }
             elsif ($container->{$key} eq 'sysdate' ) { #others as well
                    $value_clause .= "sysdate";
             }
             else {
               my $param =  DBIx::DA::Param->new({value=> $container->{$key}});
               
               $self->_add_param($param);
                  
               $value_clause.= $delimiter
                               .$param->sql($self);
                $delimiter = ", ";
             }    
        }

        $sql .= " (" . $field_clause . " ) VALUES (" . $value_clause . ")";

        # if ( $self->returning() ) {
            # $sql .= $self->_returning_clause();
        # }
    }
    return $sql;
}

sub _select_clause {
    my $self      = shift;
    my $sql       = "";
    my $delimiter = "";
    $self->_params( [] );

    #warn("\n\n\n Starting Select statement ");

    $sql .= " DISTINCT "
      if ( $self->distinct() );

    if ( $self->count_fields() || $self->count_dynamic_fields() ) {
        $sql .= $self->_field_clause( DBIx::DA::Constants::SQL::SELECT,
            $self->fields(), $self->dynamic_fields() )
          . "\n";
    }

    $sql .= $self->_from_clause() . "\n";

    if ( $self->count_join() || $self->count_dynamic_join() ) {

        $sql .= $self->_join_clause() . "\n";

    }

    if ( $self->count_where() || $self->count_dynamic_where() ) {
        $sql .= $self->_where_clause( DBIx::DA::Constants::SQL::WHERE,
            $self->where(), $self->dynamic_where() )
          . "\n";
    }

    if ( $self->count_group_by() || $self->count_dynamic_group_by() ) {
        $sql .= $self->_field_clause( DBIx::DA::Constants::SQL::GROUPBY,
            $self->group_by(), $self->dynamic_group_by() )
          . "\n";
    }
    if ( $self->count_having() || $self->count_dynamic_having() ) {
        $sql .= $self->_where_clause( DBIx::DA::Constants::SQL::HAVING,
            $self->having(), $self->dynamic_having() )
          . "\n";
    }
    if ( $self->can('hierarchical_joins') and $self->hierarchical_joins() ) {
        $sql .= $self->_hierarchical_clause() . "\n";
    }
    if ( $self->count_order_by() || $self->count_dynamic_order_by() ) {
        $sql .= $self->_field_clause( DBIx::DA::Constants::SQL::ORDERBY,
            $self->order_by(), $self->dynamic_order_by() );
    }

    #warn( "\n\n\n Finished select with SQL=" . $sql . "\n" );

    #$self->only_fields([]);#lasts only 1 select
    return ($sql);
}

sub _where_clause {

    my $self = shift;
    my ( $clause, $static, $dynamic ) = @_;

    my $sql           = " $clause ";
    my $add_condition = 0;

    foreach my $where ( ( @{$static}, @{$dynamic} ) ) {

        foreach my $predicate ( @{ $where->predicates() } ) {

            if ($add_condition) {
                if ( $predicate->condition() ) {
                    $sql .= uc( $predicate->condition() ) . " ";
                }
                else {
                    die(    "ERROR: On Dynamic " 
                          . $clause
                          . " clause: You must have a 'condition' attribute when having two or more conitions on a "
                          . $clause
                          . "." );
                }
            }
            $sql .= $predicate->sql();

            $add_condition = 1;
        }
    }

    if ( $self->_parens_are_open() ) {
        die(    "ERROR: On " 
              . $clause
              . " clause: "
              . $sql
              . ", You must close all your Parenteses!" );

    }
    else {
        $self->_reset_parens();
    }
    return $sql;

}

sub _join_clause {
    my $self = shift;
    my $sql  = " ";
    foreach my $join ( @{ $self->dynamic_joins() }, @{ $self->joins() } ) {
        $sql .= $join->sql($self);
    }

    return $sql;
}

sub _from_clause {
    my $self = shift;
    return " " . DBIx::DA::Constants::SQL::FROM . " " . $self->table()->sql();
}

sub _field_clause {
    my $self = shift;
    my ( $clause, $static, $dynamic ) = @_;
    my $delimiter = " ";
    my $sql       = " $clause";

    foreach my $field ( @{$static}, @{$dynamic} ) {
        $sql .= $field->sql( $self, $delimiter );

        $delimiter = ", ";
    }
    return $sql;
}

{
    package    #hide from pause
      DBIx::DA::Table;
    use Moose;
    with qw(DBIx::DA::SQL::Roles::Base );
    has '+name' => (
        required => 1,
        isa      => 'SQLName'
    );
    use Carp();

    has [qw(alias )] => ( is => 'rw', isa => 'SQLName|Undef' );

    sub sql {
        my $self = shift;
        if ( $self->alias() ) {
            return $self->name() . " " . $self->alias();
        }
        else {
            return $self->name();
        }
    }
}
{    #DBIx::DA::SQL::Roles::Oracle::Functions
    package    #hide from pause
      DBIx::DA::Function;
    use Moose;
    with qw(DBIx::DA::SQL::Roles::Base
      DBIx::DA::SQL::Roles::Field::Comparators);

    has 'function' => (
        isa => 'Str',
        is  => 'rw'
    );

    use Data::Dumper;

    sub sql {
        my $self = shift;
        my ($table) = @_;

        my $sql = $self->left()->_field_sql($table);

        $sql = $self->left()->expression->sql($table)
          if (  $self->left()->can('expression')
            and $self->left()->expression() );

        my $delimiter = ",";

        foreach my $opt ( @{ $self->right() } ) {

            if ( ref($opt) eq 'DBIx::DA::Field' ) {

                $sql .= $delimiter . $opt->_field_sql($table);
            }
            else {
                $sql .= $delimiter . $opt->sql($table);
            }

        }
        return $self->function() . "($sql)";
    }
}

{

    package DBIx::DA::Expression;
    use Moose;
    with qw(DBIx::DA::SQL::Roles::Base
      DBIx::DA::SQL::Roles::Field::Comparators);

    has 'expression' => (
        isa => 'SQLExpression',
        is  => 'rw'
    );

    sub sql {
        my $self = shift;
        my ( $table, $delimiter ) = @_;

#warn(" had an expression and it has a value =".$self->left()->can('expression'));

        my $sql = $self->left()->_field_sql($table);

        $sql = $self->left()->expression->sql($table)
          if (  $self->left()->can('expression')
            and $self->left()->expression() );

        $sql .= " " . $self->expression() . " ";
        if ( ref( $self->right() ) eq 'DBIx::DA::Field' ) {

            $sql .= $self->right()->_field_sql($table);
        }
        else {
            $sql .= $self->right()->sql($table);
        }
        return $delimiter . $sql
          if ($delimiter);
        return $sql;
    }

}

{

    package DBIx::DA::Field;
    use Moose;
    use Data::Dumper;
    with qw( DBIx::DA::SQL::Roles::Base );
    with 'DBIx::DA::SQL::Roles::Field::Base' => { excludes => ['expression'] };
    has '+name' => (
        isa      => 'SQLName',
        required => 1,
    );

    sub sql {
        my $self = shift;
        my ( $table, $delimiter ) = @_;
        return $delimiter . $self->_field_sql($table)
          if ($delimiter);
        return $self->_field_sql($table);
    }
}

{

    package DBIx::DA::OrderByField;
    use Moose;
    use Carp();
    use warnings;
    use strict;
    with qw(DBIx::DA::SQL::Roles::Base DBIx::DA::SQL::Roles::Field::Base  );

    has '+name' => ( isa => 'SQLName' );

    has order => (
        is      => 'rw',
        isa     => 'SQLOrder',
        default => DBIx::DA::Constants::SQL::ASC,
    );

    sub sql {
        my $self = shift;
        my ( $table, $delimiter ) = @_;

        my $sql = $self->_field_sql($table);
        $sql = $self->expression->sql($table)
          if ( $self->expression() );

        $sql = $delimiter . $sql
          if ($delimiter);

        return $sql . " " . uc( $self->order );

    }

}

{

    package DBIx::DA::SelectField;
    use Moose;
    with qw(DBIx::DA::SQL::Roles::Base DBIx::DA::SQL::Roles::Field::Base  );

    has '+name' => (
        isa      => 'SQLName',
        required => 1,
    );

    # value
    # name
    # type
    # alias
    # source
    # aggregate
    # function
    # no_select_clause
    # no_insert
    # no_update
    # returning
    # results
    # send_null
    # is_unique
    # is_identity
    # sequence
    has [
        qw(no_select_clause
          no_insert
          no_update
          returning
          send_null
          is_unique
          is_identity
          )
    ] => ( is => 'rw', isa => 'Bool|Undef' );

    has [
        qw( alias
          )
    ] => ( is => 'rw', isa => 'SQLName|Undef' );

    has aggregate => (
        is  => 'rw',
        isa => 'SQLAggregate',
    );

    sub sql {
        my $self = shift;
        my ( $table, $delimiter ) = @_;

        return ""
          if ( $self->no_select_clause() );

        my $sql = $self->_field_sql($table);
        $sql = $self->expression->sql($table)
          if ( $self->expression() );

        $sql =
            uc( $self->aggregate() )
          . DBIx::DA::Constants::SQL::OPEN_PARENS
          . $sql
          . DBIx::DA::Constants::SQL::CLOSE_PARENS
          if $self->aggregate();

        $sql .= " " . DBIx::DA::Constants::SQL::AS . " " . $self->alias()
          if ( $self->alias() );

        return $delimiter . $sql
          if ($delimiter);
        return $sql;

    }
}

{

    package DBIx::DA::Param;
    use Moose;
    use MooseX::Aliases;
    with qw(DBIx::DA::SQL::Roles::Base);

    has value => (
        is    => 'rw',
        isa   => 'Str|Undef|ArrayRef',
        alias => 'param'
    );

    has [
        qw(_use_named_params
          )
    ] => ( is => 'rw', isa => 'Bool|Undef' );

    sub sql {
        my $self = shift;
        my ($predicate) = (@_);

        use Data::Dumper;

        if ( $predicate->can('clause') ) {

            # warn("clause $predicate");
            $predicate->clause()->DA()->_add_param($self);
        }
        if ( $predicate->can('_add_param') ) {

            # warn("DA $predicate");
            $predicate->_add_param($self);
        }

        if ( $self->can('_use_named_params') and $self->_use_named_params() ) {
            return " :p_" . $self->name();
        }
        else {
            return " ? ";
        }
    }

}
{

    package DBIx::DA::OrderByParam;

    use Moose;

    extends 'DBIx::DA::Param';

    has order => (
        is      => 'rw',
        isa     => 'SQLOrder',
        default => DBIx::DA::Constants::SQL::ASC,
    );

    sub sql {
        my $self = shift;
        my ( $table, $delimiter ) = @_;

        use Data::Dumper;

        if ( $table->can('clause') ) {

            # warn("clause $predicate");
            $table->clause()->DA()->_add_param($self);
        }
        if ( $table->can('_add_param') ) {

            # warn("DA $predicate");
            $table->_add_param($self);
        }

        my $sql = " ? ";
        $sql = " :p_" . $self->name()
          if ( $self->can('_use_named_params') and $self->_use_named_params() );

        $sql = $delimiter . $sql
          if ($delimiter);

        return $sql .= " " . uc( $self->order );
    }

}
{

    package DBIx::DA::Join;
    use Moose;
    use MooseX::Aliases;
    with qw(DBIx::DA::SQL::Roles::Base DBIx::DA::SQL::Roles::Clause);
    use Data::Dumper;

    sub BUILD {
        my $self = shift;
        $self->_set_predicates();
    }

    has clause => (
        is       => 'ro',
        isa      => 'SQLJoin',
        required => 1,
    );

    has predicates => (
        traits  => ['Array'],
        is      => 'rw',
        isa     => 'ArrayRefofJoinPredicates',
        coerce  => 1,
        alias   => 'conditions',
        handles => {

            #add_join  => 'push',
            count_predicates => 'count',
        },
    );

    has table_name => (
        is       => 'rw',
        isa      => 'Str',
        required => 1,
        alias    => 'to_table'
    );

    has table_alias => (
        is    => 'rw',
        isa   => 'Str',
        alias => 'to_table_alias alias as'
    );

    sub sql {
        my $self = shift;
        my ($table) = @_;

        my $alias = $self->table_alias() ? " " . $self->table_alias() : "";

        my $sql =
            $self->clause() . " "
          . $self->table_name()
          . $alias . " "
          . DBIx::DA::Constants::SQL::ON;
        my $add_logic = 0;

        foreach my $predicate ( @{ $self->predicates() } ) {
            if ( $add_logic and $add_logic < $self->count_predicates() ) {
                if ( $predicate->operator() ) {
                    $sql .= $predicate->operator();
                }
                else {
                    die(
"ERROR: On join clause: You must have a 'operator' attribute when having two or more conitions on a JOIN."
                    );
                }
            }
            $sql .= $predicate->sql($table);
            $add_logic++;
        }

        if ( $self->DA->_parens_are_open() ) {
            die(    "ERROR: On join clause: " 
                  . $sql
                  . ", You must close your Parenteses!" );

        }
        else {
            $self->DA->_reset_parens();
        }

        return $sql;

    }
}

{

    package DBIx::DA::Where;
    use Moose;
    use MooseX::Aliases;
    with qw(DBIx::DA::SQL::Roles::Base  DBIx::DA::SQL::Roles::Clause);
    use Data::Dumper;

    sub BUILD {
        my $self = shift;
        $self->_set_predicates();

        # #warn("Build ".Dumper($self));
    }

    has '+name' => ( required => 0 );

    has operator => (
        is  => 'rw',
        isa => 'SQLOperator',

        #  default=>'='

    );

    has predicates => (
        traits  => ['Array'],
        is      => 'rw',
        isa     => 'ArrayRefofWherePredicates',
        coerce  => 1,
        alias   => 'conditions',
        handles => {

            _add_predicate   => 'push',
            count_predicates => 'count',
        },
    );

}
{

    package DBIx::DA::Join::Predicate;
    use Moose;
    with
      qw(DBIx::DA::SQL::Roles::Predicate DBIx::DA::SQL::Roles::Field::Comparators);
    use MooseX::Aliases;

    sub sql {
        my $self = shift;
        my ($table) = @_;

        return sprintf " %s %s %s ", $self->left()->sql($table),
          $self->operator,
          $self->right()->sql($table);

        #       $sql .=
    }
}

{

    package DBIx::DA::Where::Predicate;
    use Moose;
    with qw(DBIx::DA::SQL::Roles::Base
      DBIx::DA::SQL::Roles::Predicate
      DBIx::DA::SQL::Roles::Field::Comparators );
    use MooseX::Aliases;

    has condition => (
        is      => 'rw',
        isa     => 'WhereCondition',
        default => DBIx::DA::Constants::SQL::AND
    );

    sub sql {
        my $self = shift;
        my $sql;

        use Data::Dumper;

        ##warn( "predicate clause sql =" . $self->clause() );

        if ( $self->open_parenthes() ) {
            $self->clause->DA->_inc_parens;
            $sql .= DBIx::DA::Constants::SQL::OPEN_PARENS;
        }

        # #warn( "\nSEL operator " . $self->operator() . "\n" );
        if ( uc( $self->operator ) eq DBIx::DA::Constants::SQL::BETWEEN ) {

            die(
"ERROR: In SQL Where clause: The 'BETWEEN' operator requires two paramameters!"
            ) if ( scalar( @{ $self->right() } ) != 2 );

            $sql .=
                $self->left()->sql() . " "
              . DBIx::DA::Constants::SQL::BETWEEN . " "
              . $self->right->[0]->sql($self) . " "
              . DBIx::DA::Constants::SQL::AND . " "
              . $self->right->[1]->sql($self);

        }
        elsif ( uc( $self->operator ) eq DBIx::DA::Constants::SQL::LIKE ) {
            die(
"ERROR: In SQL Where clause: The 'LIKE' operator only handles Paramameters!"
            ) if ( ref( $self->right() ) ne 'DBIx::DA::Param' );
            $sql .=
                $self->left()->sql() . " "
              . DBIx::DA::Constants::SQL::LIKE . " "
              . $self->right()->sql($self);

        }
        elsif (uc( $self->operator ) eq DBIx::DA::Constants::SQL::IN
            || uc( $self->operator ) eq DBIx::DA::Constants::SQL::NOT_IN )
        {
            die(    "ERROR: In SQL Where clause: The "
                  . DBIx::DA::Constants::SQL::IN
                  . " operator only handles Paramameters or a DA ojbect!" )
              if (  ref( $self->right() ) ne 'DBIx::DA::Param'
                and ref( $self->right() ) ne 'DBIx::DA::SQL' );

            $sql .=
                $self->field()->sql() . " "
              . uc( $self->operator() ) . " "
              . DBIx::DA::Constants::SQL::OPEN_PARENS;

            if ( ref( $self->right->value() ) eq "DBIx::DA::SQL" ) {

                my $sub_select_clause = $self->right->value();
                $sql .= $sub_select_clause->_select_clause();
                foreach my $sub_param ( $sub_select_clause->dynamic_where() ) {

#                  $self->clause->_add_paramredicate($$parent->push__params( $sub_param->param() );
                }

            }
            else {

                $sql .= $self->right->sql($self);
            }
            $sql .= DBIx::DA::Constants::SQL::CLOSE_PARENS;

        }
        elsif ( uc( $self->operator ) eq DBIx::DA::Constants::SQL::IS_NULL ) {
            $sql .=
              $self->field()->sql() . " " . DBIx::DA::Constants::SQL::IS_NULL;
        }
        elsif ( uc( $self->operator ) eq DBIx::DA::Constants::SQL::IS_NOT_NULL )
        {
            $sql .=
              $self->field()->sql() . " "
              . DBIx::DA::Constants::SQL::IS_NOT_NULL;
        }
        else {

            $sql .=
                $self->left()->sql($self)
              . $self->operator
              . $self->right()->sql($self);

            #  $self->DA->_add_param( $self->param() );

        }

        if ( $self->close_parenthes() ) {
            $sql .= DBIx::DA::Constants::SQL::CLOSE_PARENS;
            $self->clause->DA->_dec_parens();
        }

        return $sql . " ";
    }
}

1;
