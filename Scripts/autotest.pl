
use 5.012;
use FindBin qw($Bin);
use lib "$Bin/lib/";
use Local::Virsorter;
use Data::Dumper;

say Dumper $Local::Virsorter::VERSION;

my $helper = Local::Virsorter->new({
	verbose => 1,
});

$helper->verbose("This");
