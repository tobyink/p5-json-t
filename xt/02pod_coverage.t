use Test::More;
use Test::Pod::Coverage;

my @modules = qw(JSON::T JSON::T::JE JSON::T::SpiderMonkey);
pod_coverage_ok($_, "$_ is covered")
	foreach @modules;
done_testing(scalar @modules);

