
# ocra RailsApp/bin/rails RailsApp --output RailsApp.exe --add-all-core --gemfile RailsApp/Gemfile --no-dep-run --gem-full --chdir-first --no-lzma --innosetup railsapp.iss -- server

desc 'build windows dist file'
task :ocra do
  options = "--output ../RailsApp.exe --add-all-core --gemfile Gemfile "
  options += "--no-dep-run --gem-full --chdir-first --no-lzma "
  options += "--dll libyaml-0-2.dll "
  # options += "--innosetup railsapp.iss -- server"
  out = %x[bundle exec ocra bin/rails . #{options} -- server]
  puts out
end
