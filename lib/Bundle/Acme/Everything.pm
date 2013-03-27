package Bundle::Acme::Everything;

use utf8;
use warnings;
use strict;
use Carp;

our $VERSION = '0.01';

use JSON;
use Furl;
use List::Util qw/first/;
use constant {
    METACPAN_BASE_URL => 'http://api.metacpan.org',
    API_DISTRIBUTION  => '/v0/distribution/_search',
};

sub _fetch_acme_module_name_list {
    my $target_name_space = 'Acme*';
    my $res_size          = '5000';    # XXX 5k is maximum of metacpan api.
                                       # If response size is more than 5k,
                                       # this module may not work rightly.
                                       # (Now, it has no problems.)
    my $query_search = "?q=$target_name_space&size=$res_size";

    my $furl = Furl->new( timeout => 15, );
    $furl->env_proxy;

    my $url_search_dists = METACPAN_BASE_URL . API_DISTRIBUTION . $query_search;
    my $res              = $furl->get($url_search_dists);
    die $! if !$res->is_success;

    my $json = JSON->new->utf8;

    my $hits = $json->decode( $res->content );

    my @modules;
    for my $hit ( @{ $hits->{hits}{hits} || [] } ) {
        my $module_name = $hit->{_id};
        $module_name =~ s/\-/::/g;
        push( @modules, $module_name ) if $module_name;
    }

    return @modules;
}

sub install_everything {
    my (@options) = @_;

    my $cpan_frontend = 'cpanm';

    my $do_test = first { $_ eq '--testament' } @options;
    push( @options, '--notest' ) unless $do_test;

    my @modules = _fetch_acme_module_name_list;

    system "$cpan_frontend @options @modules";
}

1;
__END__

=encoding utf8

=head1 NAME

Bundle::Acme::Everything - Install the all of acme modules


=head1 VERSION

This document describes Bundle::Acme::Everything version 0.01


=head1 SYNOPSIS

    use Bundle::Acme::Everything;

    Bundle::Acme::Everything->install_everything(); # => Rock'n'Roll

    # or you can execute preparated script that provides the same function

    $ bundle_acme_everything


=head1 DESCRIPTION

This module provides the only one function that installs the all of Acme modules.


=head1 NOTICE

Bundle::Acme::Everything module uses MetaCPAN API to fetch a list of all Acme modules,
so this module connects to MetaCPAN.

And Bundle::Acme::Everything installs modules without tests (it means this module always apply --notest option).
Please specify '--testament' (<= the great band!) option if you want to install modules with tests.


=head1 DEPENDENCIES

App::cpanminus (version 1.6008 or later)

JSON (version 2.53 or later)

Furl (version 2.10 or later)


=head1 BUGS AND LIMITATIONS

No bugs have been reported.


=head1 AUTHOR

moznion  C<< <moznion@gmail.com> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2013, moznion C<< <moznion@gmail.com> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
