namespace :slices do
  namespace :chefserverslice do
  
    desc "Install Chefserver"
    task :install => [:preflight, :setup_directories, :copy_assets, :migrate]
    
    desc "Test for any dependencies"
    task :preflight do # see slicetasks.rb
    end
  
    desc "Setup directories"
    task :setup_directories do
      puts "Creating directories for host application"
      ChefServerApi.mirrored_components.each do |type|
        if File.directory?(ChefServerApi.dir_for(type))
          if !File.directory?(dst_path = ChefServerApi.app_dir_for(type))
            relative_path = dst_path.relative_path_from(Merb.root)
            puts "- creating directory :#{type} #{File.basename(Merb.root) / relative_path}"
            mkdir_p(dst_path)
          end
        end
      end
    end
    
    # desc "Copy stub files to host application"
    # task :stubs do
    #   puts "Copying stubs for ChefServerApi - resolves any collisions"
    #   copied, preserved = ChefServerApi.mirror_stubs!
    #   puts "- no files to copy" if copied.empty? && preserved.empty?
    #   copied.each { |f| puts "- copied #{f}" }
    #   preserved.each { |f| puts "! preserved override as #{f}" }
    # end
    
    # desc "Copy stub files and views to host application"
    # task :patch => [ "stubs", "freeze:views" ]
  
    desc "Copy public assets to host application"
    task :copy_assets do
      puts "Copying assets for ChefServerApi - resolves any collisions"
      copied, preserved = ChefServerApi.mirror_public!
      puts "- no files to copy" if copied.empty? && preserved.empty?
      copied.each { |f| puts "- copied #{f}" }
      preserved.each { |f| puts "! preserved override as #{f}" }
    end
    
    desc "Migrate the database"
    task :migrate do # see slicetasks.rb
    end
    
    desc "Freeze ChefServerApi into your app (only chefserverslice/app)" 
    task :freeze => [ "freeze:app" ]

    namespace :freeze do
      
      # desc "Freezes ChefServerApi by installing the gem into application/gems"
      # task :gem do
      #   ENV["GEM"] ||= "chefserverslice"
      #   Rake::Task['slices:install_as_gem'].invoke
      # end
      
      desc "Freezes ChefServerApi by copying all files from chefserverslice/app to your application"
      task :app do
        puts "Copying all chefserverslice/app files to your application - resolves any collisions"
        copied, preserved = ChefServerApi.mirror_app!
        puts "- no files to copy" if copied.empty? && preserved.empty?
        copied.each { |f| puts "- copied #{f}" }
        preserved.each { |f| puts "! preserved override as #{f}" }
      end
      
      desc "Freeze all views into your application for easy modification" 
      task :views do
        puts "Copying all view templates to your application - resolves any collisions"
        copied, preserved = ChefServerApi.mirror_files_for :view
        puts "- no files to copy" if copied.empty? && preserved.empty?
        copied.each { |f| puts "- copied #{f}" }
        preserved.each { |f| puts "! preserved override as #{f}" }
      end
      
      desc "Freeze all models into your application for easy modification" 
      task :models do
        puts "Copying all models to your application - resolves any collisions"
        copied, preserved = ChefServerApi.mirror_files_for :model
        puts "- no files to copy" if copied.empty? && preserved.empty?
        copied.each { |f| puts "- copied #{f}" }
        preserved.each { |f| puts "! preserved override as #{f}" }
      end
      
      desc "Freezes ChefServerApi as a gem and copies over chefserver/app"
      task :app_with_gem => [:gem, :app]
      
      desc "Freezes ChefServerApi by unpacking all files into your application"
      task :unpack do
        puts "Unpacking ChefServerApi files to your application - resolves any collisions"
        copied, preserved = ChefServerApi.unpack_slice!
        puts "- no files to copy" if copied.empty? && preserved.empty?
        copied.each { |f| puts "- copied #{f}" }
        preserved.each { |f| puts "! preserved override as #{f}" }
      end
      
    end
    
  end
end
