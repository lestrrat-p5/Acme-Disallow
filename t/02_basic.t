use strict;
use Test::More (tests => 1);
use Test::Exception;
use Acme::Disallow qr{^File/};

dies_ok {
    require File::Spec;
} "Dies";