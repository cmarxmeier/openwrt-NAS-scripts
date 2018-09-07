#!/usr/bin/env perl

#
# quick and dirty perl script to convert wmaV2 Files to mp3 on NAS 
#

use warnings;
use strict;
use File::Find;

## for example let location be tmp
my $location="/define_basepath_here";
my $newname="";
my $source="";
my $result=0;
my $start=time;
my $duration=0;

sub find_wma {
    my $F = $File::Find::name;

        if ($F =~ /wma$/ ) {
             $start=time;
             print "$F";
             $source= $F;
             $newname=$F;
             $newname=~ s/wma/mp3/;
             print " -> $newname\n";
             print "#################################################################################\n";
             print "... converting ...\n";
             print "#################################################################################\n";
             $result=system ("nice ffmpeg -loglevel panic -hide_banner -nostats -y -i \"$F\" \"$newname\"");
             $duration = time - $start;
             if ($result == 0){
                print "#################################################################################\n";
                print "... deleting source ...\n";
                print "#################################################################################\n";
                unlink $source;
        } else {
               print "ERROR: FFMPEG aborted.\n";
               print "for file $F \n";
       }
            print "FFMPEG Execution time: $duration s\n\n";

    }
}


find({ wanted => \&find_wma, no_chdir=>1}, $location);

