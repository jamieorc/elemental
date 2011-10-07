module DangDeveloper
  module ElementalHelper
    SELF_CLOSING_TAGS = %w{ base meta link hr br param img area input col }
    XHTMLSTRICT_TAGS = %w{
      html head title base meta link style script noscript body 
      div p ul ol li dl dt dd address hr pre blockquote 
      ins del a span bdo br em strong dfn code samp 
      kbd  var  cite  abbr  acronym  q  sub  sup  tt  i  b  big  small 
      object  param  img  map  area  form  label  input  select  optgroup  option 
      textarea  fieldset  legend  button  table  caption  colgroup  col 
      thead  tfoot  tbody  tr  th  td  h1  h2  h3  h4  h5  h6 
    }
    # From http://dev.w3.org/html5/spec-author-view/index.html#elements-1 on 2011-10-05
    HTML5_TAGS = %w{
      a abbr address area article aside audio 
      b base bdi bdo blockquote body br button 
      canvas caption cite code col colgroup command 
      datalist dd del details dfn div dl dt 
      em embed 
      fieldset figcaption figure footer form 
      h1 h2 h3 h4 h5 h6 
      head header hgroup hr html 
      i iframe img input ins 
      kbd keygen 
      label legend li link 
      map mark menu meta meter 
      nav noscript 
      object ol optgroup option output 
      p param pre progress 
      q rp rt ruby 
      s samp script section select small source 
      span strong style sub summary sup 
      table tbody td textarea tfoot th thead time title tr track 
      u ul var video wbr
    }
    XHTMLTRANSITIONAL_TAGS = %w{ strike center dir noframes basefont u menu iframe font s applet isindex }
    EXISTING_RAILS_METHODS = %w{ form input select label }
    XHTML_CONTENT_TAGS = (XHTMLSTRICT_TAGS + XHTMLTRANSITIONAL_TAGS) - SELF_CLOSING_TAGS - EXISTING_RAILS_METHODS
    
    def self.self_closing_tags
      SELF_CLOSING_TAGS
    end
    
    def self.xhtml_content_tags
      XHTML_CONTENT_TAGS
    end
    
    XHTML_CONTENT_TAGS.each do |element|
      eval("def #{element}(*args, &block); block ? content_tag_block('#{element}', *args, &block) : tag_without_block('#{element}', *args); end") 
    end
    SELF_CLOSING_TAGS.each do |element|
      eval("def #{element}(options={}); tag('#{element}', options, false); end")
    end
    def content_tag_block(tag_name, *args, &block)
      options = args.first.is_a?(Hash) ? args.shift : {}
      concat content_tag(tag_name, capture(&block), options)
    end

    def tag_without_block(tag_name, *args)
      content  = args.first.is_a?(Hash) ? nil : args.shift
      options = args.first.is_a?(Hash) ? args.shift : {}
      options.stringify_keys! 
      # still deciding syntax...
      # content = options.delete "content" if options.has_key? "content"

      if SELF_CLOSING_TAGS.include?(tag_name.to_s)
        tag(tag_name, options, false)
      else
        content_tag(tag_name, content, options)
      end
    end
  end
end