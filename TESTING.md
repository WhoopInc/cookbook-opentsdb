# TESTING

Thanks to Chef Software, Inc. for the test configuration and writing the
[initial version of this guide][chef-client-guide] in their chef-client
cookbook.

## Style

Lint Ruby with Rubocop:

```
rake style:ruby
```

Lint the Chef cookbook with Foodcritic:

```
rake style:chef
```

## Unit

Unit testing is done with RSpec. RSpec will test any
libraries, then test recipes using ChefSpec. This works by compiling a
recipe (but not converging it), and allowing the user to make
assertions about the resource_collection.

```
rake spec
```

## Integration

Integration testing is performed by Test Kitchen. Test Kitchen will
use either the Vagrant driver or various cloud drivers to instantiate
machines and apply cookbooks. After a successful converge, tests are
uploaded and ran out of band of Chef. Tests should be designed to
ensure that a recipe has accomplished its goal.

### Vagrant

Integration tests can be performed on a local workstation using
Vagrant. You'll need Vagrant installed.

```
rake kitchen
```

### AWS EC2

Integration tests can be performed on cloud providers using
Test Kitchen plugins. This cookbook ships a `.kitchen.cloud.yml`
that references environmental variables present in the shell that
`kitchen test` is run from. These usually contain authentication
tokens for driving IaaS APIs, as well as the paths to ssh private keys
needed for Test Kitchen log into them after they've been created.

Examples of environment variables being set in ```~/.bash_profile```:
```
# aws
export AWS_ACCESS_KEY_ID='your_bits_here'
export AWS_SECRET_ACCESS_KEY='your_bits_here'
export AWS_KEYPAIR_NAME='your_bits_here'
```

Run inte

```
KITCHEN_LOCAL_YAML=.kitchen.cloud.yml bundle exec rake kitchen
```

## Travis CI

In order for Travis to perform integration tests on public cloud
providers, two major things need to happen. First, the environment
variables referenced by `.kitchen.cloud.yml` need to be made
available. Second, the private half of the SSH keys needed to log into
machines need to be dropped off on the machine.

The first part is straight forward. The travis gem can encrypt
environment variables against the public key on the Travis repository
and add them to the `.travis.yml`.

```
gem install travis
travis encrypt AWS_ACCESS_KEY_ID='your_bits_here' --add
travis encrypt AWS_SECRET_ACCESS_'your_bits_here' --add
travis encrypt AWS_KEYPAIR_NAME='your_bits_here' --add
travis encrypt AWS_SSH_KEY_PATH='~/.ssh/id_ci.pem' --add
```

The second part is a little more complicated. Travis ENV variables are
restricted to 90 bytes, and will not fit an entire SSH key. This can
be worked around by breaking them up into 90 byte chunks, stashing
them into ENV variables, then digging them out in the
```before_install``` section of .travis.yml

Here is an AWK script to do the encoding.

```bash
base64 ~/.ssh/ci.pem |
  awk '{
    j=0;
    for( i=1; i<length; i=i+90 ) {
      system("travis encrypt AWS_KEY_CHUNK_" j "=" substr($0, i, 90)" --add");
      j++;
    }
  }'
```

Then in `.travis.yml`:

```yaml
before_install:
- echo -n $AWS_KEY_CHUNK_{0..30} >> ~/.ssh/id_ec2.base64
- cat ~/.ssh/id_ci.base64 | tr -d ' ' | base64 --decode > ~/.ssh/id_ci.pem
```

[chef-client-guide]: https://github.com/opscode-cookbooks/chef-client/blob/master/TESTING.md
