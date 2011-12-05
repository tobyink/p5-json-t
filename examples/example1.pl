use 5.010;
use JSON::JOM;
use JSON::T;

my $input = JSON::JOM::from_json(<<'JSON');
{
	"$transformation": "http://buzzword.org.uk/2008/jsonGRDDL/jsont-sample#Person",
	"name": "Joe Bloggs",
	"mbox": "joe@example.net" 
}
JSON

my $transformation = <<'JSONT';
var namePrefix = "";

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
					"value" : namePrefix + x.name
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

my $T    = JSON::T->new($transformation);
$T->parameters(namePrefix => 'Mr ');

my $output = JSON::JOM::to_jom($T->transform_structure($input));

say "#### $T";
say $output->dump;