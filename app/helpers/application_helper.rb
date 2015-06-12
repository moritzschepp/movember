module ApplicationHelper
  def mdv_button(content, target, options = {})
    content = (block_given? ? yield : content)
    target = (block_given? ? content : target)
    options.merge!(:class => 'btn btn-primary')
    link_to content, target, options
  end
  
  def mdv_button_small(content, target, options = {})
    content = (block_given? ? yield : content)
    target = (block_given? ? content : target)
    options.merge!(:class => 'btn btn-primary btn-mini')
    link_to content, target, options
  end
  
  def mdv_button_star(content, target, options = {})
    content = (block_given? ? yield : content)
    target = (block_given? ? content : target)
    options.merge!(:class => 'btn btn-primary')
    star = content_tag('i', nil, :class => 'icon-star icon-white')
    link_to star + ' ' + content, target, options
  end
  
  def label_for_state(state, value = nil)
    klass = case state
      when 'open' then 'label-success'
      when 'disabled' then ''
      when 'voted' then 'label-info'
    end
    
    value ||= state
    
    content_tag 'span', value, :class => "label #{klass}"
  end

  def text_logo
    image_tag "/assets/logo.small.png", :class => "text_logo"
  end
  
end
