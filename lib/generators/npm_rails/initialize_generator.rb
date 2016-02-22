module NpmRails
  class InitializeGenerator < Rails::Generators::Base
    desc 'Adds a boilerplate package_file to the root of Rails project'
    source_root File.expand_path('../templates', __FILE__)

    def create_package_file
      copy_file 'npm_packages', 'npm_packages'
    end

    def add_to_gitignore
      append_to_file ".gitignore" do
        <<-EOF.strip_heredoc
        # Added by npm-rails
        /node_modules
        /vendor/assets/javascripts/npm-dependencies.js
        EOF
      end
    end
  end
end
