
# ocra RailsApp/bin/rails RailsApp --output RailsApp.exe --add-all-core --gemfile RailsApp/Gemfile --no-dep-run --gem-full --chdir-first --no-lzma --innosetup railsapp.iss -- server

desc 'remove RailsApp.exe'
task :rm do
  %x[rm ../RailsApp.exe]
end

desc 'build windows dist file'
task :ocra => [:environment, :rm] do
  Creation.all.each do |c| c.destroy! end
  Rake::Task["assets:clobber"].invoke    
  Rake::Task["assets:precompile"].invoke  
  options = "--output ../RailsApp.exe --add-all-core --gemfile Gemfile "
  options += "--no-dep-run --gem-full --chdir-first " # --no-lzma "
  options += "--dll libyaml-0-2.dll "
  options += "--no-enc "
  # options += "--innosetup railsapp.iss -- server"
  out = %x[bundle exec ocra bin/rails . #{options} -- server -e production]
  puts out
end
