use strict;
use warnings;
use Module::Build::Pluggable (
    '+Module::Build::Pluggable::CPANfile',
);

my $builder = Module::Build::Pluggable->new(
    name              => 'Bundle-AcmeEverything',
    module_name       => 'Bundle::Acme::Everything',
    script_files      => ['script/bundle_acme_everything'],
    license           => 'perl',
    dist_author       => 'moznion <moznion@gmail.com>',
    dist_version_from => 'lib/Bundle/Acme/Everything.pm',
    requires           => {
        perl             => '5.008009',
    },
    no_index   => { 'directory' => ['inc'] },
    meta_merge => {
        'resources' => {
            'license' => 'http://dev.perl.org/licenses/',
            'repository' =>
              'git://github.com/moznion/p5-Bundle--Acme--Everything.git',
        },
    },
    test_files => ( -d '.git' || $ENV{RELEASE_TESTING} ) ? 't/ xt/' : 't/',
    recursive_test_files => 1,
    add_to_cleanup       => ['Bundle-Acme-Everything-*'],
    create_license       => 1,
    create_readme        => 1,
);

$builder->create_build_script();
