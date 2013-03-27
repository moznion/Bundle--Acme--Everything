#!perl

use strict;
use warnings;
use utf8;

use Test::More;

eval "use Test::Vars";
plan skip_all => "Test::Vars required for testing variables" if $@;

vars_ok('lib/Bundle/Acme/Everything.pm');

done_testing;
