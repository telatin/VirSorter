use 5.012;
use warnings;
use FindBin qw($Bin);
use LWP::Simple;
use File::Spec::Functions;
use File::Path 'mkpath';
use Archive::Tar;
use File::HomeDir;
use Test::More;

# Input dataset:
my $input = "$Bin/contigs.fa";		# Test contigs set
my $expected_ctgs = 5;			# Expected number of matches in the $input file

# Change this to your path of "VIRSORTER DATA" (default is the docker image path)
my $data = '/data/';

# Temporary directory
my $tmp  = catdir(File::HomeDir->my_home, 'virsorter-test');

my $bin   = "$Bin/../wrapper_phage_contigs_sorter_iPlant.pl";

ok(-e $bin, "Binary found: $bin");
ok(-e $input, "Input file found: $input");

if (! -e "$input") {
	die " * Input file not found: <$input>";
}

# This test script will put data in $HOME/virsorter-test/virsorter-data/ 
if (! -d "$data") {
	# Change to "home downloaded" path
	$data = catdir($tmp, 'virsorter-data');

	if (!-e catfile($data, 'Dockerfile') ) {
		say STDERR " * Attempting to download to $data: ",catfile($data, 'Dockerfile') ," not found...";
		die "Unable to download.\n" unless (get_data());	
	}
	ok(-d "$data", "Data dir found in TEST made path: $data");
} else {
	ok(-d "$data", "Data dir found in declared path: $data");
}

my $outdir = catdir($Bin, 'out');
if (-d "$outdir") {
	`rm -rf $outdir`;
}

# RUN THE PROGRAM

my $cmd = qq($bin --fna "$input" --data-dir "$data" --wdir "$outdir");

`$cmd`;
ok($?==0, "Program run without errors");

# CHECK THE PROGRAM OUTPUT
my $virsorter_out = catfile($outdir, 'VIRSorter_global-phage-signal.csv');
ok(-s "$virsorter_out", "Virsorter output file found");
open my $V, '<', "$virsorter_out" || die;
my $predictions = 0;
while (my $line = readline($V)) {
	next if ($line =~/^##/);
	$predictions++;
}
ok($predictions == $expected_ctgs, "$expected_ctgs predicted phage contigs in test dataset");

done_testing();

sub get_data {
	my $tar_file = catfile($tmp, "virsorter.tgz");
	say STDERR " * Needing: $tar_file";
	if (! -e "$tar_file") {
	    	say STDERR "   * Downloading";
		my $url = "https://zenodo.org/record/1168727/files/virsorter-data-v2.tar.gz";
		mkpath($tmp);
		#getstore($url, $file);	
		`wget --quiet -O "$tar_file" "$url"`;
		die "Unable to download: 'wget' failed.\n" if ($?);
	}
	say STDERR " * Expanding $tar_file";
	`tar xfz "$tar_file" -C "$tmp" `;
	say STDERR "   * Done";
	die "Unable to download: 'tar' failed: ", qq(tar xfz -C "$tmp" "$tar_file"), "\n" if ($?);
		#my $tar = Archive::Tar->new;
		#$tar->setcwd($tmp);
		#$tar->read($tar_file);
		#$tar->extract();

	return 1 unless $@;
}
