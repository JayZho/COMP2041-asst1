#!/usr/bin/perl -w

#get current branch and the to-merge branch
#$mergeB = $ARGV[0];
#open my $curr, '<', "./.legit/commits/currBranch" or die;
#$currB = <$curr>;
#chomp $currB;

#get current commit on the to-merge branch
#open my $com, '<', "./.legit/commits/branches/$mergeB/currCommit" or die;
#$mergeCommit = <$com>;

#use LCS;

use Algorithm::Diff;
use Algorithm::Merge;

open my $a, '<', $ARGV[0] or die;
while ($line = <$a>){
	push @seqA, $line;
}
close($a);

open my $b, '<', $ARGV[1] or die;
while ($line = <$b>){
	push @seqB, $line;
}
close($b);


$diff = Algorithm::Diff->new(\@seqA,\@seqB);
while($sec = $diff -> Next()){
	print "sec: ===$sec===\n";
	print "$diff->Diff\n";
}



