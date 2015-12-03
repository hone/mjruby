require 'rbconfig'
require 'fileutils'

# There must be a Makefile or RubyGems will freak out. So we create
# a no-op Makefile
File.write('Makefile', <<EOF)
clean:

install:
EOF

bindir = RbConfig::CONFIG['bindir']
arch   = "#{ENV_JAVA['os.arch']}-#{ENV_JAVA['os.name']}"

binary =
  case arch
  when /^(amd64|x86_64)-Linux/   then "mruby/build/x86_64-pc-linux-gnu/bin/mjruby"
  when /^i\d86-Linux/            then "mruby/build/i686-pc-linux-gnu/bin/mjruby"
  when /^x86_64-Mac OS X/        then "mruby/build/x86_64-apple-darwin14/bin/mjruby"
  when /^i\d86-Mac OS X/         then "mruby/build/x86_64-apple-darwin14/bin/mjruby"
  when /^x86-Windows/            then "mruby/build/i686-w64-mingw32/bin/mjruby"
  when /^(amd64|x86_64)-Windows/ then "mruby/build/x86_64-w64-mingw32/bin/mjruby"
  when /^x86-FreeBSD/            then "mruby/build/i686-pc-freebsd7/bin/mjruby"
  when /^(amd64|x86_64)-FreeBSD/ then "mruby/build/x86_64-pc-freebsd7/bin/mjruby"
  else nil
    raise "Could not find appropriate architecture for '#{arch}'"
  end
FileUtils.cp(binary, bindir)
