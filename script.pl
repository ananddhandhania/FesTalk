################ Set system location #################
sub set_system
{
	use FindBin '$Bin';
	open(MYIN,"<${Bin}/system.conf");
	foreach $line(<MYIN>)
	{
		my($first,$rest)= split (/\s+/,$line,2);
		chomp $rest;
		${$first}=$rest;
	}
	close(MYIN);
}

#### Set Language from Language ID ##########
######## It reads Language from Language_ID.conf #############
sub set_language
{
	use FindBin '$Bin';
	open(MYIN,"<${Bin}/Language_ID.conf");
	foreach $line(<MYIN>)
	{
		my($first,$rest)= split (/\s+/,$line,2);
		chomp $rest;
		if ($first == @_[0] ) {$Language = $rest;}
	}
	if($Language eq "default")
	{
		my $string = "There is no Language for the given Language ID. For more details check file \"Language_ID.conf\". ";
		generate_error($string);
	}
	close(MYIN);
}

###### Generating error ##########
###### can be updated rationally ########
sub generate_error
{
	open(MYOUT,">${home}ini/${Token}");
	print MYOUT "Error @_";
	close(MYOUT);
	exit 1;
}

##### Sub Routine to set default values ######
sub default
{
	$Text = "default";
	$Language_ID = 0;
	$Token = 0;
	$Language="default";
}


##############################################
################ Begin #######################
##############################################
use utf8;
set_system();
$Text,$Language_ID = default();

###################
##READ CONF FILE###
###################
$filename= "$ARGV[0]";
#$filename="$ARGV[0]";
if(-e $filename)
 {
	open(MYIN,"<:encoding(UTF-8)","$ARGV[0]");
 }
else { 
  exit 123;
}

foreach $line(<MYIN>)
{
	$line =~ s/\r\n$/\n/;
	my($first,$rest)= split (/\s+/,$line,2);
	chomp $rest;
	$$first = $rest;
}
close(MYIN);


####### Error call when some of the parameters are missing in the file ############
if($Language_ID == 0) 
{ 
	my $string = "No Language Selected";
	generate_error($string);
}

if($Text eq "default")
{
	my $string = "No Text input";
	generate_error($string);
}

if($Token eq 0) 
{
	exit 122;
}

$Language eq set_language($Language_ID);
#################### Generate Festival Script #######################
use FindBin '$Bin';
open(MYOUT,">${Bin}/festival/festival${Token}");
print MYOUT "(",$Language,")\n";
binmode(MYOUT, ":utf8");
print "(Utterance Text ",$Text,") \"${home}wave/${Token}\")\n" ;
print MYOUT "(utt.save.wave (utt.synth (Utterance Text ",$Text,")) \"${home}wave/${Token}\")\n";
print MYOUT "(quit)";
close(MYOUT);
#####################################################################

###################Run Festival and receive output in output array. 2>&1 since festival prints in stderr ####################################
@output = `festival ${Bin}/festival/festival${Token} 2>&1`;
`rm ${Bin}/festival/festival${Token}`;
use List::MoreUtils 'any';
my $match_found = any { /not member of PhoneSet/ } @output;
if ($match_found == 1) 
{
	my $string = "Language and Text mismatch";
	generate_error($string);
}
open(MYOUT,">${home}ini/${Token}");
print MYOUT "Process Complete";
close(MYOUT);
exit $Token;
###### Add new errors and pattern in similar manner ###########
#my $match_found = any { /has no duration info/ } @output;
#generate_error(@output);

##########################################################################


