require 'fileutils'

JS_ROOT = File.join(RAILS_ROOT, "public", "javascripts")
CSS_ROOT = File.join(RAILS_ROOT, "public", "stylesheets")
IMAGES_ROOT = File.join(RAILS_ROOT, "public", "images")
GROWLR_ROOT = File.join(RAILS_ROOT, "vendor", "plugins", "growlr")
PLUGIN_CSS_PATH = File.join(GROWLR_ROOT, "css")
PLUGIN_JS_PATH = File.join(GROWLR_ROOT, "js")

namespace :growlr do
  
  namespace :install do
    
    desc 'Installs the image files the examples folder'
    task :images do
      images = Dir.glob(File.join(GROWLR_ROOT, "examples", "*.png"))
      FileUtils.cp_r(images, IMAGES_ROOT)
      puts "Growlr images have been installed!"
    end
    
    desc 'Installs the js files --add JQUERY=true to add jquery 1.2.6 core file'
    task :js do
      js_files = File.join(PLUGIN_JS_PATH, "jquery.jgrowl_compressed.js")
      js_files << File.join(PLUGIN_JS_PATH, "jquery.css") unless ENV['JQUERY'].nil?
      FileUtils.cp_r(js_files, JS_ROOT)
      puts "Growlr javascript files have been installed!"
    end
    
    desc 'Installs the css files'
    task :css do
      css_files = File.join(PLUGIN_CSS_PATH, "jquery.jgrowl.css")
      FileUtils.cp_r(css_files, CSS_ROOT)
      puts "Growlr css files have been installed!"
    end
    
    desc 'Installs all the files'
    task :all, :needs => [ 'growlr:install:images', 'growlr:install:js', 'growlr:install:css'] do
      footer = "Growlr has been installed!"
      puts footer
      puts "-"*footer.length
      puts "Just put <%= include_growlr %> in your layout file and you're good to go!"
    end
  end
  
end
