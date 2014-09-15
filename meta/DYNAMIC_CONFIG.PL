if (eval { require JavaScript::SpiderMonkey })
{
	print "You have JavaScript::SpiderMonkey... awesome!\n";
}
else
{
	print "You are missing JavaScript::SpiderMonkey... but fear not!\n";
	print "We'll add a pure Perl Javascript implementation (JE) to your deps.\n";
	
	$meta->{prereqs}{runtime}{requires}{'JE'} = 0;
}

if (eval { require Cpanel::JSON::XS })
{
	print "You have Cpanel::JSON::XS... awesome!\n";
}
else
{
	print "You are missing Cpanel::JSON::XS... but fear not!\n";
	print "We'll add a pure Perl JSON implementation (JSON::PP) to your deps.\n";
	
	$meta->{prereqs}{runtime}{requires}{'JSON::PP'} = 0;
}
