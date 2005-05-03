use Module::Build;
my $build = Module::Build->new
      ( module_name    => 'Text::FixEOL',
        dist_author    => 'Benjamin Franz <snowhare@nihongo.org>',
        dist_abstract  => 'Canonicalizes mixed convention EOL/EOF',
        license        => 'perl',
        build_requires => {
                'Test::More'       => '0.54',
                'Test::NoWarnings' => '0.07',
                },
      )->create_build_script;
