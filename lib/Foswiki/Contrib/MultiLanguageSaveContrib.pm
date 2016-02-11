package Foswiki::Contrib::MultiLanguageSaveContrib;

use strict;
use warnings;

use Foswiki::UI::Save;

our $VERSION = '1.0.0';

our $RELEASE = "1.0.0";

our $SHORTDESCRIPTION = 'Multi language autoinc.';

sub saveml {
    my $session = shift;

    my $query = $session->{request};

    my ( $web, $originalTopic ) =
      $session->normalizeWebTopicName( $session->{webName},
        $session->{topicName} );

    my $topic = $originalTopic;
    if($topic =~ m#(.*)(AUTOINC\d+)(.*)-([A-Z]{2}$)#) {
        my ($pre, $auto, $suff, $lang) = ($1, $2, $3, $4);

        my @langs = split(m#\s*,\s*#, $query->param('languages') || '');
        push(@langs, $lang) unless scalar grep { $_ eq $lang } @langs;

        my $min = 0;
        foreach my $eachLang ( @langs ) {
            my $topicLang = "$pre$auto$suff-$eachLang";
            $topicLang = Foswiki::UI::Save::expandAUTOINC( $session, $web, $topicLang );
            $topicLang =~ s#^\Q$pre\E##;
            $topicLang =~ s#\Q$suff\E-$eachLang$##;
            die $topicLang unless $topicLang =~ m#^\d+$#;
            $min = $topicLang if($topicLang > $min);
        }

        $topic = "$pre$min$suff-$lang";

        # Replace references to original topic name with resolved topic.
        # Otherwise /pub/Web/...AUTOINC... will not be picked up by WysiwygPlugin.
        # XXX Hopefully no-one will talk about AUTOINC topics.
        my $text = $query->param('text');
        if(defined $text && $text =~ s#\Q$originalTopic\E#$topic#g) {
            $query->param('text', $text);
        }

        $session->{topicName} = $topic;
        $query->param('topic', $topic) if $query->param('topic');
        $ENV{FOSWIKI_ACTION} = 'save';
    }

    Foswiki::UI::Save::save($session);
}

1;

