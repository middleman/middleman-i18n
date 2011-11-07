module Middleman
  module Features
    module I18n
      class << self
        def registered(app)
          ::I18n.load_path += Dir[File.join(app.root, "locales", "*.yml")]

          # require "middleman/guard"
          # require "guard/livereload"

          # Middleman::Guard.add_guard do
          #   %Q{
          #     guard 'middleman' do 
          #       watch(%r{^locales/^[^\.](.*)\.yml$})
          #     end
          #   }
          # end

          app.extend ClassMethods
        end
        alias :included :registered
      end
      
      module ClassMethods
        def localize(options={})
          langs = options[:langs] || begin
            Dir[File.join(settings.root, "locales", "*.yml")].map do |file|
              File.basename(file).gsub(".yml", "").to_sym
            end
          end
          
          lang_map      = options[:lang_map]      || {}
          path          = options[:path]          || "/:locale/"
          templates_dir = options[:templates_dir] || "localizable"
          mount_at_root = options.has_key?(:mount_at_root) ? options[:mount_at_root] : langs.first
          
          if !settings.views.include?(settings.root)
            settings.set :views, File.join(settings.root, settings.views)
          end
          
          files = Dir[File.join(settings.views, templates_dir, "**/*")]
          
          langs.each do |lang|
            # Set current locale
            ::I18n.locale = lang
            
            # Build lang path
            if mount_at_root == lang
              prefix = "/"
            else
              replacement = lang_map.has_key?(lang) ? lang_map[lang] : lang
              prefix = path.gsub(":locale", replacement.to_s)
            end

            files.each do |file|
              url = file.gsub(settings.views, "").split(".html").first + ".html"
              
              page_id = File.basename(url, File.extname(url))
              localized_page_id = ::I18n.t("paths.#{page_id}", :default => page_id)
              localized_url = File.join(prefix, url.gsub(templates_dir + "/", "")).gsub(page_id, localized_page_id)

              page localized_url, :proxy => url, :ignore => true do
                ::I18n.locale = lang
                @lang         = lang
                @page_id      = page_id
              end
            end
          end
          
          settings.after_configuration do
            if !settings.build?
              $stderr.puts "== Locales: #{langs.join(", ")}"
            end
          end
        end
      end
    end
  end
end