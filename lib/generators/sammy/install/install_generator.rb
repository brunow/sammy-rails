module Sammy
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "This generator downloads and install the newest Sammy jQuery plugin"
      @@default_version = "0.6.2"
      class_option :version, :type => :string,  :default => @@default_version.dup, :desc => "Which version of Sammy to fetch ?"
      class_option :plugin,  :type => :boolean, :default => false,                 :desc => "Do you want to fetch all plugin ?"
      
      def download_sammy
        say_status("fetching", "Sammy #{options.version}", :green)
        get_sammy(options.version)
      rescue OpenURI::HTTPError
        say_status("warning", "could not find Sammy #{options.version}", :yellow)
        say_status("fetching", "Sammy #{@@default_version}", :green)
        get_sammy(@@default_version)
      end
      
      private
        def get_sammy(version)
          js_path   = "public/javascripts"
          sammy_url = "https://github.com/quirkey/sammy/raw/v#{version}/lib"
          
          get "#{sammy_url}/sammy.js", "#{js_path}/sammy.js"
          get "#{sammy_url}/min/sammy-latest.min.js", "#{js_path}/sammy.min.js"
          
          if options.plugin?
            %w{ cache data_location_proxy ejs form googleanalytics haml handlebars json meld mustache nested_params path_location_proxy pure storage template title tmpl }.each do |plugin|
              get "#{sammy_url}/min/plugins/sammy.#{plugin}-latest.min.js", "#{js_path}/sammy/sammy.#{plugin}.min.js"
              get "#{sammy_url}/plugins/sammy.#{plugin}.js", "#{js_path}/sammy/sammy.#{plugin}.js"
            end
          end
        end
    end
  end
end