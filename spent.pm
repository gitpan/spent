#!/usr/bin/perl
################################################################################
# spent.pm 	-- functions for reading shadow database
# AUTHOR	: Samuel Behan <behan@frida.fri.utc.sk> (c) 2000-2001
# LICENSE	: GNU GPL v2 or later, NO WARANTY VOID
# RETURN ARRAY  :
# ($name, $password, $change_last, $change_may, $change_must, $change_warn,
#	$max_inactive, $expire_date)	= getsp*
# NOTE		: This is my 'fast' implementation, done because standart perl
#		  distribution does not contains, somethink like this
################################################################################

package spent;
use strict;
use integer;
use vars (qw(@ISA @EXPORT $VERSION $AUTHOR), qw($open_state));
require Exporter;
@ISA	= qw(Exporter);
@EXPORT	= qw(setspent getspent getspnam endspent);
$VERSION= '0.1';
$AUTHOR	= 'Samuel Behan <behan@frida.fri.utc.sk>';


$open_state	= 0;

##
# Open shadow database for reading
sub setspent(;$)
{
  open(SHADOW,$_[0] || "/etc/shadow") || return undef;
  $open_state	= 1;
  return 1;
}

##
# Close shadow database
sub endspent
{
  $open_state || return undef;
  close(SHADOW) || return undef;
  $open_state	= 0;
  return 1;
}

##
# Get next entry from shadow database
sub getspent
{
  my ($line,@sp_ent);
  $open_state || setspent() || return undef;
  if(!($line	= <SHADOW>))	#stupit way of reading file
  { return @sp_ent; }
  chomp($line);
  @sp_ent	= split(/:/,$line,9);		
  return wantarray ? @sp_ent : "@sp_ent";
}
 
##
# Get shadow entry matching name
sub getspnam($)
{
  if(!$open_state)
  { setspent() || return undef; }
  my ($line,$name,@sp_ent);
  while($line	= <SHADOW>)
  { chomp($line);
    $name	= $line;
    $name	=~ s/:.*//;
    if($name	eq $_[0])
    { my @sp_ent	= split(/:/,$line,9);
      return wantarray ? @sp_ent : "@sp_ent"; } }
  return wantarray ? @sp_ent : "@sp_ent";
}
  
1;
