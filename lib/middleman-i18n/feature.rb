module Middleman
  module Features
    module I18n
      class << self
        def registered(app)
          app.set :locales_dir, "locales"

          app.extend ClassMethods
          
          app.after_configuration do
            ::I18n.load_path += Dir[File.join(app.root, app.locales_dir, "*.yml")]
          end
        end
        alias :included :registered
      end
      
      class Localizer
        def initialize(app)
          @app = app
          @maps = {}
        end
        
        def setup(options)
          @options = options
          
          @lang_map      = @options[:lang_map]      || {}
          @path          = @options[:path]          || "/:locale/"
          @templates_dir = @options[:templates_dir] || "localizable"
          @mount_at_root = @options.has_key?(:mount_at_root) ? @options[:mount_at_root] : langs.first
          
          @source_dir = File.expand_path(@app.views, @app.root)
          Dir[File.join(source_dir, @templates_dir, "**/*")].each do |f|
            touch_file(f)
          end
          
          if !@app.build?
            puts "== Locales: #{langs.join(", ")}"
          end
        end
        
        def langs
          @options[:langs] || begin
            Dir[File.join(@app.root, @app.locales_dir, "*.yml")].map do |file|
              File.basename(file).gsub(".yml", "").to_sym
            end
          end
        end
        
        def touch_file(file)
          remove_file(file) if @maps.has_key?(file)
          
          url = @app.sitemap.source_map.index(file)
          @app.ignore(url)
          
          @maps[file] = paths_for_file(file).map do |data|
            lang, path, page_id = data
            
            @app.page(localized_url, :proxy => url) do
              ::I18n.locale = lang
              @lang         = lang
              @page_id      = page_id
            end
            
            path
          end
        end
        
        def remove_file(file)
          url = @app.sitemap.source_map.index(file)
          @app.sitemap.set(url, true)
          
          @maps[file].each do |path|
            @app.sitemap.remove_path(path)
          end
          
          @maps.delete(file)
        end
        
        def paths_for_file(file)
          url = @app.sitemap.source_map.index(file)
          page_id = File.basename(url, File.extname(url))
          
          langs.map do |lang|
            ::I18n.locale = lang
            
            # Build lang path
            if @mount_at_root == lang
              prefix = "/"
            else
              replacement = @lang_map.has_key?(lang) ? @lang_map[lang] : lang
              prefix = @path.sub(":locale", replacement.to_s)
            end
            
            localized_page_id = ::I18n.t("paths.#{page_id}", :default => page_id)
            
            path = File.join(prefix, url.sub(page_id, localized_page_id))
            [lang, path, localized_page_id]
          end
        end
      end
      
      module ClassMethods
        def i18n
          @i18n ||= Localizer.new(self)
        end
        
        def localize(options={})
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
          
          settings.file_changed do |file|
            settings.i18n.touch_file(file)
          end

          settings.file_deleted do |file|
            settings.i18n.remove_file(file)
          end
          
          settings.after_configuration do
            settings.i18n.setup
          end
        end
      end
    end
  end
end