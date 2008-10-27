module Growlr
  
  JS_PATH = File.join(RAILS_ROOT, "public", "javascripts")
  GROWLR_SRC = File.join(JS_PATH, "load-growlr.js")
  # the growl cache is used for permanent messages such as flash notices
  GROWLR_CACHE = File.join(RAILS_ROOT, "tmp", ".growlr_cache")
  
  def include_growlr(include_jquery=false)
    clean_growlr_cache
    growl_flash_messages
    generate_js all_messages
    clean_growlr_msgs
    js << 'jquery.js' if include_jquery
    js = %w(jquery.jgrowl_compressed.js load-growlr)
    content = javascript_include_tag(js)
    content << stylesheet_link_tag("jquery.jgrowl.css")
    return content
  end
  
  def growl(message, options={})
    options[:cache] ||= false
    cached = options[:cache]
    options.delete :cache
    
    growl_without_options = "\n$.jGrowl('#{message}');"
    growl_with_options = "\n$.jGrowl('#{message}', #{options.to_json});"
    msg = options.blank? ? growl_without_options : growl_with_options
    cached ? append_growlr_cache(msg) : append_growlr_msg(msg)
  end
  
  protected
  
  def growl_flash_messages
    flash.keys.each do |key|
      growl(flash[key], :cache => true) unless flash[key].blank?
    end
  end
  
  def all_messages
    notices = cookies[:notices].blank? ? "" : cookies[:notices]
    IO.read(GROWLR_CACHE) << notices
  end
  
  def append_growlr_msg(content)
    cookies[:notices] ||= ""
    cookies[:notices] << content
  end
  
  def clean_growlr_msgs
    cookies[:notices] = ""
  end
  
  def append_growlr_cache(content)
    File.open GROWLR_CACHE, "a+" do |cache|
      cache << content
    end
  end
  
  def clean_growlr_cache
    File.open GROWLR_CACHE, "w+" do |cache|
      cache = ""
    end
  end
  
  def js_head
    return "(function($){\n$(document).ready(function(){"
  end
  
  def js_foot
    return "\n});\n})(jQuery);"
  end
  
  def generate_js(content)
    File.open(GROWLR_SRC, "w+") do |file|
      file << js_head
      file << content
      file << js_foot
    end
  end
  
end