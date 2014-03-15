name             'opentsdb'
maintainer       'whoop, Inc.'
maintainer_email 'benesch@whoop.com'
license          'All rights reserved'
description      'Installs/Configures opentsdb'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.1'

supports 'ubuntu', '= 12.04'

depends 'apt',  '~> 2.3.0'
depends 'java', '~> 1.21.0'
