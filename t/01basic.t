use Test::More tests => 3;
BEGIN { use_ok('JSON::T') };

my $json = <<'JSON';
{
	"$transformation" : "http://buzzword.org.uk/2008/jsonGRDDL/jsont-sample#Person" ,
	"name" : "Joe Bloggs" ,
	"mbox" : "joe@example.net" 
}
JSON

my $jsont = <<'JSONT';
var People =
{
	"self" : function(x)
	{
		var rv = {};
		for (var i=0; x.people[i]; i++)
		{
			var person = JSON.parse(Person.self(x.people[i]));
			rv["_:Contact" + i] = person["_:Contact"];
		}
		return JSON.stringify(rv, 0, 2);
	}
};

var Person =
{
	"self" : function(x)
	{
		var rv =
		{
			"_:Contact" :
			{
				"http://www.w3.org/1999/02/22-rdf-syntax-ns#type" :
				[{
					"type" : "uri" ,
					"value" : "http://xmlns.com/foaf/0.1/Person"
				}],
				"http://xmlns.com/foaf/0.1/name" :
				[{
					"type" : "literal" ,
					"value" : x.name
				}],
				"http://xmlns.com/foaf/0.1/mbox" :
				[{
					"type" : "uri" ,
					"value" : "mailto:" + x.mbox
				}]
			}
		};
		return JSON.stringify(rv, 0, 2);
	}
};

var _main = Person;
JSONT

my $T = JSON::T->new($jsont);
my $R = $T->transform_structure($json);

ok($R, 'returned something that smelt like JSON');
is($R->{'_:Contact'}->{'http://www.w3.org/1999/02/22-rdf-syntax-ns#type'}->[0]->{'type'},
	'uri', 'returned data seems sound');