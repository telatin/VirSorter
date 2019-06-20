package Local::Virsorter;
use 5.014;
use warnings;
use Term::ANSIColor;
use Carp qw(confess);
$Local::Virsorter::VERSION = '0.1';

sub new {
    # Instantiate object
    my ($class, $args) = @_;

    my $self = {
        verbose       => $args->{verbose},
	verbose_color => $args->{verbose_color} // 'cyan',
    };

    
    my $object = bless $self, $class;
    return $object;
}

sub verbose {
        my ($self, $text) = @_;
        return unless ($self->{verbose});
        print STDERR color($self->{verbose_color}), ""  unless (defined $ENV{'NO_COLOR'});
        say STDERR  " * $text";
        print STDERR color('reset'), "" unless (defined $ENV{'NO_COLOR'});
}

1;
