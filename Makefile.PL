require spent;
use ExtUtils::MakeMaker;
$verbose = 1;
WriteMakefile(
  NAME => "spent.pm",
  DISTNAME => "spent.pm",
  VERSION_FROM => 'spent.pm',
  'dist' => {COMPRESS=>'gzip -9f', SUFFIX => '.gz'}
);
