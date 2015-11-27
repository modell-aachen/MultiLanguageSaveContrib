# ---+ Extensions
# ---++ MulitSaveLanguageContrib
# **PERL H**
# This setting is required to enable executing the saveml script from the bin directory
$Foswiki::cfg{SwitchBoard}{saveml} = {
    package  => 'Foswiki::Contrib::MultiLanguageSaveContrib',
    function => 'saveml',
    context  => { save => 1, saveml => 1 },
};

1;
