#!/usr/bin/perl -w


use Algorithm::Diff;

open my $a, '<', $ARGV[0] or die;
while ($line = <$a>){
	push @seq_a, $line;
}
close($a);

open my $b, '<', $ARGV[1] or die;
while ($line2 = <$b>){
	push @seq_b, $line2;
}
close($b);

diff


#my @seq_a = qw(       a x b y c z p d q 1 2 3 4 ! 5 6 7);
#my @seq_b = qw( a b c a x b y c z       1 2 3 4 ? 5 6 7);

#
#  Turn seq_a into seq_b
#:x

#  This is the array that will contain
#  the same values as @seq_b:

my @seq_B = ();


#
#  new computes the smallest set of additions and deletions
#  necessary to turn the first sequence into the second.
#
my $diff = Algorithm::Diff->new(\@seq_a, \@seq_b);

while (my $hunk = $diff -> Next()) {
#	print "\n";
	#  ----------------------------------
	print "\$hunk: $hunk ";
    print "Diff: ", $diff->Diff(), " ";
    print "Same " if $diff->Same();
    #print "\n";
    my @items_a = $diff -> Items(1);
    my @items_b = $diff -> Items(2);
    push @seq_B, @items_b;
    print "  A: " . (join "-", @items_a) . "\n";
    print "  B: " . (join "-", @items_b) . "\n";
}
#print "------------------------\n";
#print ((join "-", @seq_b),"\n");
#print ((join "-", @seq_B),"\n");

