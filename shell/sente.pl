#!/usr/bin/perl

use Digest::MD5 qw(md5_hex);

$ifconfigin = `/sbin/ifconfig en0 | grep ether`;
$macaddr = substr($ifconfigin, index($ifconfigin, ":")-2, 17);
$macaddr =~ s/\://g;

$sntype = "Sente6";
$snprefix = "TSS-AC-$sntype-";
$sntime = "perpetual";
$sn2hash = "ZTSSZACZ". $sntype . "Z". $macaddr . "Z" . "$sntime" . "Z";
$sndigest = md5_hex($sn2hash);

$sn = $snprefix . $macaddr . "-$sntime" . "_$sndigest";

print "\nSente 6.x Perpetual Authorization Code for this mac:\n$sn\n\n";

$licfile = "Sente 6 Authorization Code";

open (LIC, "> $licfile") or die "Cannot create the license file:\n$!\n";
print LIC "$sn\n";
close (LIC);

print "Copy the file \"$licfile\" from the current directory to:\n" 
	. $ENV{'HOME'} . "/Library/Application Support/Sente/License/Sente6/Mac." 
	. $macaddr . "/\n" . "(if the destination path doesn't exist, create it).\n\n";
