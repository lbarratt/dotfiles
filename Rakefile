require "rake"

desc "Install dotfiles into the home directory"
task :install do
  system %Q{mkdir -p ~/.tmp}
  system %Q{mkdir -p ~/.config}
  system %Q{mkdir -p ~/.config/alacritty}
  system %Q{mkdir -p ~/.config/nvim}

  replace_all = false

  Dir["*"].each do |file|
    next if %w[Brewfile Rakefile README.md LICENSE config].include? file

    if File.exist?(File.join(ENV["HOME"], ".#{file}"))
      if replace_all
        replace_file(file)
      else
        print "overwrite ~/.#{file}? [ynaq] "
        case $stdin.gets.chomp
        when "a"
          replace_all = true
          replace_file(file)
        when "y"
          replace_file(file)
        when "q"
          exit
        else
          puts "skipping ~/.#{file}"
        end
      end
    else
      link_file(file)
    end
  end

  replace_file "config/nvim/init.lua"
  replace_file "config/alacritty/alacritty.toml"
  replace_file "config/alacritty/catppuccin-mocha.toml"
end

def replace_file(file)
  system %Q{rm "$HOME/.#{file}"}
  link_file(file)
end

def link_file(file)
  puts "linking ~/.#{file}"
  system %Q{ln -s "$PWD/#{file}" "$HOME/.#{file}"}
end
