module Growlr
  
  JS_PATH = File.join(RAILS_ROOT, "public", "javascripts")
  # the growl cache is used for permanent messages such as flash notices
  GROWLR_CACHE = File.join(RAILS_ROOT, "tmp", ".growlr_cache")
  
  # TODO : maybe look to add in a JS proxy for easier js generation 
  def include_growlr(include_jquery=false)
    clean_growlr_msgs
    clean_growlr_cache
    growl_flash_messages
    js = include_jquery ? 'jquery.js' : ""
    js << "jquery.jgrowl_compressed.js"
    content = "#{stylesheet_link_tag('jquery.jgrowl.css')}\n"
    content << "#{javascript_include_tag(js)}\n"
    content << generate_js(all_messages)
    return content
  end
  
  def growl(message, options={})
    options[:cache] ||= false
    cached = options[:cache]
    options.delete :cache
    message.gsub! /[']/, '\\\\\''
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
    return '' if content.to_s.empty?
    <<-JS
      \n<script type="text/javascript" charset="utf-8">\n
      #{js_head}\n
        #{content}\n
      #{js_foot}\n  
      </script>\n
    JS
  end
  
end
