package Yacht;

use strict;
use warnings;
use experimental qw<signatures postderef postderef_qq>;

use Exporter qw<import>;
our @EXPORT_OK = qw<score>;

use List::Util qw(uniq sum all);

sub score ( $category, $dice ) {
    if    ( $category eq 'yacht' )  { scalar( uniq @$dice ) == 1 ? 50 : 0; }
    elsif ( $category eq 'choice' ) { sum @$dice; }
    elsif ( $category eq 'ones' )   { single( 1, $dice ); }
    elsif ( $category eq 'twos' )   { single( 2, $dice ); }
    elsif ( $category eq 'threes' ) { single( 3, $dice ); }
    elsif ( $category eq 'fours' )  { single( 4, $dice ); }
    elsif ( $category eq 'fives' )  { single( 5, $dice ); }
    elsif ( $category eq 'sixes' )  { single( 6, $dice ); }
    elsif ( $category eq 'full house' )      { full_house($dice); }
    elsif ( $category eq 'four of a kind' )  { four_kind($dice); }
    elsif ( $category eq 'little straight' ) { straight( $dice, [ 1 .. 5 ] ); }
    elsif ( $category eq 'big straight' ) { straight( $dice, [ 2 .. 6 ] ); }
}

sub single ( $die, $dice ) { $die * grep { $_ == $die } @$dice; }

sub full_house($dice) {
    my @s = sort { $a <=> $b } @$dice;
    $s[0] != $s[4] && (
        ( $s[0] == $s[1] && $s[2] == $s[4] ) ||
        ( $s[0] == $s[2] && $s[3] == $s[4] )
        )
        ? sum(@$dice)
        : 0;
}

sub four_kind($dice) {
    my @s = sort { $a <=> $b } @$dice;
    ( $s[0] == $s[3] || $s[1] == $s[4] ) ? 4 * $s[2] : 0;
}

sub straight( $dice, $wanted ) {
    my @sorted = sort { $a <=> $b } @$dice;
    ( all { $sorted[$_] == $wanted->[$_] } 0 .. 4 ) ? 30 : 0;
}

1;
