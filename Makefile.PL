use inc::Module::Install;

# Define metadata
name            'Test-Chimps';
all_from        'lib/Test/Chimps.pm';

# Specific dependencies
requires('Algorithm::TokenBucket');
requires('Class::Accessor');
requires('DateTime');
requires('HTML::Mason');
requires('TAP::Formatter::HTML');
requires('TAP::Parser::Aggregator');
requires('TAP::Harness::Archive');
requires('Jifty::DBI::Collection');
requires('Jifty::DBI::Handle');
requires('Jifty::DBI::Record');
requires('Jifty::DBI::Schema');
requires('Jifty::DBI::SchemaGenerator');
requires('Params::Validate');
requires('YAML::Syck');

build_requires('Test::Dependencies');

extra_tests;

auto_install;
WriteAll;
