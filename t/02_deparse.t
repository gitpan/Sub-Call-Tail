#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use Sub::Call::Tail;

use B::Deparse;

sub bar { (caller(1))[3] }

sub invoke {
    my $sub = shift;
    $sub->();
}


my $sub = sub { tail bar() };

is( invoke(\&bar), "main::invoke", "normal call" );
is( invoke($sub), "main::invoke", "tail call" );

my $source = B::Deparse->new->coderef2text($sub);

like( $source, qr/tail/, "source mentions tail" );

my $new = eval "sub $source";

is( ref($new), 'CODE', "compiled a coderef" );

is( invoke($new), "main::invoke", "compiled coderef has valid tail call" );

done_testing;

# ex: set sw=4 et:

