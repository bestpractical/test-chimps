package Test::Chimps::Report;

use warnings;
use strict;

use Carp;
use Params::Validate qw/:all/;
use Test::TAP::HTMLMatrix;
use YAML::Syck;

=head1 NAME

Test::Chimps::Report - Encapsulate a smoke test report

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

This module encapsulates a L<Test::TAP::Model>'s structure and a
freeform report text.  If not provided, Test::TAP::HTMLMatrix will
be used to generate the report.

    use Test::Chimps::Report;
    use Test::TAP::Model::Visual;

    chdir "some/module/directory";

    my $model = Test::TAP::Model::Visual->new_with_tests(glob("t/*.t"));

    my $report = Test::Chimps::Report->new(model => $model);

    ...

=head1 METHODS

=head2 new ARGS

Creates a new Report.  ARGS is a hash whose valid keys are:

=over 4

=item * model

Mandatory and must be an instance of C<Test::Tap::Model>.

=item * report_text

A free-form report.  If not supplied, it is filled in using
C<Test::TAP::HTMLMatrix>, and C<extra_data> will be passed as the
C<extra> argument to its constructor.  Note that if you are using
this class in conjunction with C<Test::Chimps::Server>,
C<report_text> should probably be HTML.

=item * report_variables

Report variables to be transmitted with the report.  The decision
of which variables should be submitted is made by the server.

=back

=cut

use base qw/Class::Accessor/;

__PACKAGE__->mk_ro_accessors(
  qw/model_structure
    report_text report_variables/
);


sub new {
  my $class = shift;
  my $obj = bless {}, $class;
  $obj->_init(@_);
  return $obj;
}

sub _init {
  my $self = shift;
  validate_with(
    params => \@_,
    called => 'The Test::Chimps::Report constructor'
    spec   => {
      model            => { isa => 'Test::TAP::Model' },
      report_text      => 0,
      report_variables => {
        optional => 1,
        type     => HASHREF
      }
    },
  );

  my %args = @_;

  $self->{model_structure} = $args{model}->structure;
  if (defined $args{report_text}) {
    $self->{report_text} = $args{report_text};
  } else {
    my $v;
    if (defined $args{report_variables}) {
      $v = Test::TAP::HTMLMatrix->new($args{model},
                                      Dump($args{report_variables}));
      $self->{report_variables} = $args{report_variables};
    } else {
      $v = Test::TAP::HTMLMatrix->new($args{model});
      $self->{report_variables} = '';
    }
    $v->has_inline_css(1);
    $self->{report_text} = $v->detail_html;
  }
}

=head1 ACCESSORS

There are read-only accessors for model_structure, report_text, and
report_variables.

=head1 AUTHOR

Zev Benjamin, C<< <zev at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-test-chimps at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Test-Chimps>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Test::Chimps

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Test-Chimps>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Test-Chimps>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Test-Chimps>

=item * Search CPAN

L<http://search.cpan.org/dist/Test-Chimps>

=back

=head1 ACKNOWLEDGEMENTS

The code in this distribution is based on smokeserv-client.pl and
smokeserv-server.pl from the Pugs distribution.

=head1 COPYRIGHT & LICENSE

Copyright 2006 Zev Benjamin, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
