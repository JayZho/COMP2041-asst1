#!/usr/bin/perl -w

#get current branch and the to-merge branch
$mergeB = $ARGV[0];
open my $curr, '<', "./.legit/commits/currBranch" or die;
$currB = <$curr>;
chomp $currB;

#get current commit on the to-merge branch
open my $com, '<', "./.legit/commits/branches/$mergeB/currCommit" or die;
$mergeCommit = <$com>;



