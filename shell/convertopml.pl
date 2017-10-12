#!/usr/bin/perl
# Converts OPML to org-mode
# perl convert.pl file.opml > file.org
use XML::Parser;
binmode STDOUT, ":utf8";
$xp = new XML::Parser();
$xp->setHandlers(Start => \&start, End => \&end);
$xp->parsefile($ARGV[0]);

$indent = 0;

sub start() {
  my ($parser, $name, %attr) = @_;
  if ($name eq "outline") {
    for($i = 0; $i < $indent; $i++) { print "*"; }
    if ($indent > 0) { print " "};
    print "$attr{text}\n";
    $indent += 1;
  }
}

sub end() {
  my ($parser, $name) = @_;
  if($name eq "outline") { $indent -= 1; }
}
