#!perl

use strict;
use warnings;
use utf8;

use Bundle::Acme::Everything;

use Test::More;

subtest 'should fetch module names that starts "Acme"' => sub {
    my @modules = Bundle::Acme::Everything->_fetch_acme_module_name_list;
    foreach my $module (@modules) {
        ok $module =~ /Acme.*/i;
    }
};

done_testing;
