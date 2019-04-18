#!/usr/bin/env perl

### Copyright 2019 Flavio Licciulli
###

# A program to map slices from GRCh38 assemblies to GRCh37 assembly.

use strict;
use warnings;
use Getopt::Long;

use Bio::EnsEMBL::Registry;

my ( $chromosome, $start, $end );
my $help = '';

# Input parameters management
if ( !GetOptions( 'chromosome|c=s' => \$chromosome,
                  'start|s=i' => \$start,
                  'end|e=i' => \$end,
                  'help|h!' => \$help )
     || !( defined($chromosome) && defined($start) && defined($end))
     || $help )
{
  print <<END_USAGE;

Usage:
  $0 --chromosome=chromosome --start=start --end=end
  $0 --help
    --chromosome / -c  	Chromosome name.
    --start / -s  		Chromosome region start
    --end / -e  		Chromosome region end
    --help / -h  To see this text.

Example usage:
  $0 -c 10 -s 25000 -e 30000

END_USAGE

  exit(1);
} 

# Public Ensembl Database Connection
my $ensembldb_conn = 'Bio::EnsEMBL::Registry';

$ensembldb_conn->load_registry_from_db(
    -host => 'ensembldb.ensembl.org', 
	-port => 3306,
    -user => 'anonymous'
);

# Get a Slice adaptor
my $slice_adaptor_GRCh38 = $ensembldb_conn->get_adaptor( 'Human', 'Core', 'Slice' );

print "Input: $chromosome $start-$end\n";

# Create a slice for the given coordinates
#my $slice_GRCh38 = $slice_adaptor_GRCh38->fetch_by_region( 'chromosome', '10', 25000, 30000 );
my $slice_GRCh38 = $slice_adaptor_GRCh38->fetch_by_region( 'chromosome', $chromosome, $start, $end );

# Load and print info about coordinate system (GRCh38) and chromosome region
my $coord_sys  = $slice_GRCh38->coord_system()->name();
my $cversion   = $slice_GRCh38->coord_system()->version();
my $cseq_region= $slice_GRCh38->seq_region_name();
my $cstart     = $slice_GRCh38->start();
my $cend       = $slice_GRCh38->end();
my $cstrand    = $slice_GRCh38->strand();

print "Slice_GRCh38: $coord_sys $cseq_region $cstart-$cend ($cstrand)\n";

# Project the GRCh38 slice to the GRCh37 assembly 
# Display information about each resulting segment
  foreach my $segment ( @{ $slice_GRCh38->project('chromosome', 'GRCh37') } ) {
	printf( "%s:%s:%s:%d:%d:%d => %s\n",
            $coord_sys,
            $cversion,
            $cseq_region,
            $cstart + $segment->from_start() - 1,
            $cstart + $segment->from_end() - 1,
            $cstrand,
            $segment->to_Slice()->name() );

			}
	
exit(0);	
# end
