def debug(msg)
  puts msg if ENV['MJRUBY_DEBUG']
end

def warn(msg)
  puts "WARNING: #{msg}"
end

def __main__(argv)
  command = argv.shift
  jruby_support = JRubySupport.new(command)
  cli_opts = JRubyOptsParser.parse!(jruby_support.jruby_opts_env + argv)
  java_class = "org/jruby/Main"
  jruby_home = jruby_support.jruby_home
  jruby_cp = jruby_support.jruby_classpath
  classpath = jruby_cp + JavaSupport.cp_delim + (
      cli_opts.classpath +
      jruby_support.classpath
    ).map{|f| File.realpath(f)}.join(JavaSupport.cp_delim)
  jruby_opts = cli_opts.jruby_opts

  all_java_opts = jruby_support.default_java_opts +
    java_opts(cli_opts.java_opts) + jffi_opts(jruby_home) + [
      "-Xbootclasspath/a:#{jruby_cp}",
      "-Djava.class.path=#{classpath}",
      "-Djruby.home=#{jruby_home}",
      "-Djruby.lib=#{jruby_home}/lib",
      "-Djruby.script=jruby",
      "-Djruby.shell=#{JRubySupport::SYSTEM_SHELL}"]

  if cli_opts.verify_jruby
    # TODO ???
  else
    debug "java #{all_java_opts} #{java_class} #{cli_opts.ruby_opts}"
    JavaSupport.new.exec_java(java_class, all_java_opts, cli_opts.ruby_opts)
  end
end
