use strict;
use warnings;

use Test::More;

use blib ('./blib','../blib');
use lib  ('./lib', '../lib');
eval "use Pod::Coverage 0.17";
if ( $@ ) {
    plan skip_all => "Pod::Coverage 0.17 required for testing POD coverage";
    exit;
}

plan tests => 1;

my $pc = Pod::Coverage->new( 'package' => 'Text::FixEOL',
                             also_private => ['DEBUG']);
my $coverage = $pc->coverage;
if ($coverage < 1) {
    my @uncovered = $pc->uncovered;
    diag("uncovered subs: " . join(', ',@uncovered));
    ok(0, 'pod coverage');
} else {
    ok(1, 'pod coverage');
}
