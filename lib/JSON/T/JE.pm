package JSON::T::JE;

use 5.010;
use strict;
use warnings;
use utf8;

use JE;

use base qw[JSON::T];

BEGIN
{
	$JSON::T::JE::AUTHORITY = 'cpan:TOBYINK';
	$JSON::T::JE::VERSION   = '0.102';
}

sub init
{
	my ($self, @args) = @_;
	
	my $JS = $self->{engine} = JE->new;
	
	$JS->new_function("return_to_perl", sub
		{
			$self->_accept_return_value(@_);
		});
	$JS->new_function("print_to_perl", sub
		{
			print @_;
		});

	$self->SUPER::init(@args);
}

sub engine_eval
{
	my ($self, $code) = @_;
	$self->{engine}->eval($code);
}

sub parameters
{
	my ($self, %args) = @_;
	while (my ($k,$v) = each %args)
	{
		if (ref $v eq 'ARRAY')
		{
			$v = $v->[1];
		}
		$self->{'engine'}->eval("var $k;");
		$self->{'engine'}->eval($k)->set(
			JE::Object::String->new($self->{'engine'}, $v)
			);
	}
}

1;

=head1 NAME

JSON::T::JE - transform JSON using JsonT and JE

=head1 DESCRIPTION

This module uses L<JE> to provide JavaScript support.

Implements:

=over

=item C<init>

=item C<engine_eval>

=item C<parameters>

=back

=head1 BUGS

Please report any bugs to L<http://rt.cpan.org/>.

=head1 SEE ALSO

L<JSON::T>.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

Copyright 2008-2011, 2013 Toby Inkster.

Licensed under the Lesser GPL:
L<http://creativecommons.org/licenses/LGPL/2.1/>.

=head1 DISCLAIMER OF WARRANTIES

THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.

=cut
