#!/usr/bin/perl -Tw

use strict;
use warnings;

use blib ('./blib','../blib');

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Text-FixEOL.t'

#########################
# change 'tests => 3' to 'tests => last_test_to_print';


use Test::More (tests => 8);
use Test::NoWarnings;

#########################
# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

#########
# Test 1
BEGIN {
    use_ok('Text::FixEOL');
}

#########
# Test 2
require_ok ('Text::FixEOL');

#########
# Test 3
ok (test_unix_eol());

#########
# Test 4
ok (test_dos_eol());

#########
# Test 5
ok (test_mac_eol());

#########
# Test 6
ok (test_network_eol());

#########
# Test 7
ok (test_handlers_and_modes());

#########
# the 'NoWarnings' test is implicitly test 
# N+1 from the last explict test

exit;

#####################################################################
#####################################################################

sub test_handlers_and_modes {
    my $fixer = Text::FixEOL->new;
   unless ($fixer->eol_handling eq 'platform') {
        diag("Default EOL handling was NOT 'platform'");
        return 0;
    }
    unless ($fixer->eof_handling eq 'platform') {
        diag("Default EOL handling was NOT 'platform'");
        return 0;
    }
    unless ($fixer->fix_last_handling eq 'platform') {
        diag("Default 'fix last' handling was NOT 'platform'");
        return 0;
    }

    $fixer->eol_handling('dos');
    unless ($fixer->eol_handling eq 'dos') {
        diag("Setting of eol_handling failed. Expected 'dos', got '" . $fixer->eol_handling . "'");
        return 0;
    }
    unless ($fixer->eol_mode eq "\015\012") {
        diag("eol mode incorrect for DOS");
        return 0;
    }

    $fixer->eol_handling('unix');
    unless ($fixer->eol_handling eq 'unix') {
        diag("Setting of eol_handling failed. Expected 'unix', got '" . $fixer->eol_handling . "'");
        return 0;
    }
    unless ($fixer->eol_mode eq "\012") {
        diag("eol mode incorrect for Unix");
        return 0;
    }

    $fixer->eol_handling('mac');
    unless ($fixer->eol_handling eq 'mac') {
        diag("Setting of eol_handling failed. Expected 'mac', got '" . $fixer->eol_handling . "'");
        return 0;
    }
    unless ($fixer->eol_mode eq "\015") {
        diag("eol mode incorrect for Mac");
        return 0;
    }

    $fixer->eol_handling('network');
    unless ($fixer->eol_handling eq 'network') {
        diag("Setting of eol_handling failed. Expected 'network', got '" . $fixer->eol_handling . "'");
        return 0;
    }
    unless ($fixer->eol_mode eq "\015\012") {
        diag("eol mode incorrect for network");
        return 0;
    }
    return 1;
}

#########################

sub test_unix_eol {
    my $map_list = map_list();
    my $fixer    = Text::FixEOL->new;
    my $counter  = 0;
    foreach my $map_pair (@$map_list) {
        my ($source_string, $target_string) = @$map_pair;
        my $fixed_string = $fixer->eol_to_unix($source_string);
        if ($fixed_string ne $target_string) {
            $source_string = url_escape($source_string);
            $fixed_string  = url_escape($fixed_string);
            $target_string = url_escape($target_string);
            diag("unix data line $counter: did not convert '$source_string' correctly. Expected '$target_string', got '$fixed_string'");
            return 0;
        }
        $counter++;
    }
    return 1;
}

#########################

sub test_dos_eol {
    my $map_list = map_list();
    my $fixer    = Text::FixEOL->new;
    my $counter  = 0;
    foreach my $map_pair (@$map_list) {
        my ($source_string, $target_string) = @$map_pair;
        $target_string =~ s/\012/\015\012/gs;
        my $fixed_string = $fixer->eol_to_dos($source_string);
        if ($fixed_string ne $target_string) {
            $source_string = url_escape($source_string);
            $fixed_string  = url_escape($fixed_string);
            $target_string = url_escape($target_string);
            diag("dos data line $counter: did not convert '$source_string' correctly. Expected '$target_string', got '$fixed_string'");
            return 0;
        }
        $counter++;
    }
    return 1;
}

#########################

sub test_mac_eol {
    my $map_list = map_list();
    my $fixer    = Text::FixEOL->new;
    my $counter  = 0;
    foreach my $map_pair (@$map_list) {
        my ($source_string, $target_string) = @$map_pair;
        $target_string =~ s/\012/\015/gs;
        my $fixed_string = $fixer->eol_to_mac($source_string);
        if ($fixed_string ne $target_string) {
            $source_string = url_escape($source_string);
            $fixed_string  = url_escape($fixed_string);
            $target_string = url_escape($target_string);
            diag("mac data line $counter: did not convert '$source_string' correctly. Expected '$target_string', got '$fixed_string'");
            return 0;
        }
        $counter++;
    }
    return 1;
}

#########################

sub test_network_eol {
    my $map_list = map_list();
    my $fixer    = Text::FixEOL->new;
    my $counter  = 0;
    foreach my $map_pair (@$map_list) {
        my ($source_string, $target_string) = @$map_pair;
        $target_string =~ s/\012/\015\012/gs;
        my $fixed_string = $fixer->eol_to_network($source_string);
        if ($fixed_string ne $target_string) {
            $source_string = url_escape($source_string);
            $fixed_string  = url_escape($fixed_string);
            $target_string = url_escape($target_string);
            diag("network data line $counter: did not convert '$source_string' correctly. Expected '$target_string', got '$fixed_string'");
            return 0;
        }
        $counter++;
    }
    return 1;
}
#########################

sub url_escape {
    my ($s)=@_;
    return '' unless defined ($s);
    $s=~s/([\000-\377])/"\%".unpack("H",$1).unpack("h",$1)/egs;
    $s;
}

#########################

sub map_list {
    my $map_list = [
    ["\012" => "\012"],
    ["\015" => "\012"],

    ["\012\015" => "\012"],
    ["\015\012" => "\012"],
    ["\015\012\015" => "\012\012"],
    ["\012\015\012" => "\012\012"],

    ["\012a\012b\012" => "\012a\012b\012"],
    ["\012a\012b\015" => "\012a\012b\012"],
    ["\012a\015b\012" => "\012a\012b\012"],
    ["\012a\015b\015" => "\012a\012b\012"],
    ["\015a\012b\012" => "\012a\012b\012"],
    ["\015a\012b\015" => "\012a\012b\012"],
    ["\015a\015b\012" => "\012a\012b\012"],
    ["\015a\015b\015" => "\012a\012b\012"],

    ["\012\015a\012\015b\012\015" => "\012a\012b\012"],
    ["\012\015a\012\015b\015"     => "\012a\012b\012"],
    ["\012\015a\015b\012\015"     => "\012a\012b\012"],
    ["\012\015a\015b\015"         => "\012a\012b\012"],
    ["\015a\012\015b\012\015"     => "\012a\012b\012"],
    ["\015a\012\015b\015"         => "\012a\012b\012"],
    ["\015a\015b\012\015"         => "\012a\012b\012"],

    ["\015\012a\015\012b\015\012" => "\012a\012b\012"],
    ["\015\012a\015\012b\015"     => "\012a\012b\012"],
    ["\015\012a\015b\015\012"     => "\012a\012b\012"],
    ["\015\012a\015b\015"         => "\012a\012b\012"],
    ["\015a\015\012b\015\012"     => "\012a\012b\012"],
    ["\015a\015\012b\015"         => "\012a\012b\012"],
    ["\015a\015b\015\012"         => "\012a\012b\012"],
    ["\015\012\015a\015\012\015b\015\012\015" => "\012\012a\012\012b\012\012"],
    ["\015\012\015a\015\012\015b\015"         => "\012\012a\012\012b\012"],
    ["\015\012\015a\015b\015\012\015"         => "\012\012a\012b\012\012"],
    ["\015\012\015a\015b\015"                 => "\012\012a\012b\012"],
    ["\015a\015\012\015b\015\012\015"         => "\012a\012\012b\012\012"],
    ["\015a\015\012\015b\015"                 => "\012a\012\012b\012"],
    ["\015a\015b\015\012\015"                 => "\012a\012b\012\012"],

    ["\012\012\012a\012\012\012b\012\012\012" => "\012\012\012a\012\012\012b\012\012\012"],
    ["\012\012\015a\012\012\015b\012\012\015" => "\012\012a\012\012b\012\012"],
    ["\012\015\012a\012\015\012b\012\015\012" => "\012\012a\012\012b\012\012"],
    ["\012\015\015a\012\015\015b\012\015\015" => "\012\012a\012\012b\012\012"],
    ["\015\012\012a\015\012\012b\015\012\012" => "\012\012a\012\012b\012\012"],
    ["\015\012\015a\015\012\015b\015\012\015" => "\012\012a\012\012b\012\012"],
    ["\015\015\012a\015\015\012b\015\015\012" => "\012\012a\012\012b\012\012"],
    ["\015\015\015a\015\015\015b\015\015\015" => "\012\012\012a\012\012\012b\012\012\012"],

  ["\012\012\012\012a\012\012\012\012b\012\012\012\012" => "\012\012\012\012a\012\012\012\012b\012\012\012\012"],
  ["\012\012\012\015a\012\012\012\015b\012\012\012\015" => "\012\012\012a\012\012\012b\012\012\012"],
  ["\012\012\015\012a\012\012\015\012b\012\012\015\012" => "\012\012\012a\012\012\012b\012\012\012"],
  ["\012\012\015\015a\012\012\015\015b\012\012\015\015" => "\012\012\012a\012\012\012b\012\012\012"],
  ["\012\015\012\012a\012\015\012\012b\012\015\012\012" => "\012\012\012a\012\012\012b\012\012\012"],
  ["\012\015\012\015a\012\015\012\015b\012\015\012\015" => "\012\012a\012\012b\012\012"],
  ["\012\015\015\012a\012\015\015\012b\012\015\015\012" => "\012\012a\012\012b\012\012"],
  ["\012\015\015\015a\012\015\015\015b\012\015\015\015" => "\012\012\012a\012\012\012b\012\012\012"],
  ["\015\012\012\012a\015\012\012\012b\015\012\012\012" => "\012\012\012a\012\012\012b\012\012\012"],
  ["\015\012\012\015a\015\012\012\015b\015\012\012\015" => "\012\012a\012\012b\012\012"],
  ["\015\012\015\012a\015\012\015\012b\015\012\015\012" => "\012\012a\012\012b\012\012"],
  ["\015\012\015\015a\015\012\015\015b\015\012\015\015" => "\012\012\012a\012\012\012b\012\012\012"],
  ["\015\015\012\012a\015\015\012\012b\015\015\012\012" => "\012\012\012a\012\012\012b\012\012\012"],
  ["\015\015\012\015a\015\015\012\015b\015\015\012\015" => "\012\012\012a\012\012\012b\012\012\012"],
  ["\015\015\015\012a\015\015\015\012b\015\015\015\012" => "\012\012\012a\012\012\012b\012\012\012"],
  ["\015\015\015\015a\015\015\015\015b\015\015\015\015" => "\012\012\012\012a\012\012\012\012b\012\012\012\012"],
    ];
    return $map_list;
}
