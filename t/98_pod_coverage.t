use strict;
use warnings;

use Test::More;

use blib ('./blib','../blib');
use lib  ('./lib', '../lib');
eval "use Test::Pod::Coverage";
if ( $@ ) {
    plan skip_all => "Test::Pod::Coverage required for testing POD coverage";
    exit;
}

plan tests => 1;

pod_coverage_ok( 'Text::FixEOL',
    {
        also_private => ['DEBUG']
    }
);

