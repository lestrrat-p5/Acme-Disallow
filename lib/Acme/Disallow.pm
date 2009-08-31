package Acme::Disallow;
use strict;
use Carp;

sub import {
    my ($class, @list) = @_;

    @list = map {
        if (! ref $_ ) {
            s/::/\//g;
            s/$/\.pm/;
        }
        qr($_);
    } grep {
        !ref $_ || ref $_ eq 'Regexp';
    } @list;

    return unless @list;

    my ($caller, $file, $line) = caller;

    my $sub = "sub {\n";
    foreach my $entry (@list) {
        $entry =~ s/\//\\\//g;
        $sub .= qq|    Carp::croak "Use of \$_[1] is disallowed (decalred at $file line $line)" if \$_[1] =~ /$entry/;\n|;
    }
    $sub .= "    return undef;\n}";

    my $code = eval $sub or die;
    unshift @INC, $code;
}

1;

__END__

=head1 NAME

Acme::Disallow - Disallow Loading Some Modules

=head1 SYNOPSIS

    use Acme::Disallow qw(XML::LibXML);
    use XML::LibXML; # dies

    use Acme::Disallow
        qr{^XML/LibXML(/.+)\.pm$}
    ;
    use XML::LibXML::Atom; # dies
        

=head1 DESCRIPTION

This module disallows the use of certain modules by name.

=head1 CAVEATS

This is an Acme module. Use it at your own risk

=head1 AUTHOR

Daisuke Maki C<< <daisuke@endeworks.jp> >>

=cut