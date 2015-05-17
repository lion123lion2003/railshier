module ApplicationHelper
  def delete_link(url, options={})
    options = {
      :method => :delete,
      :data => {:confirm => t(:text_are_you_sure)},
      :class => 'icon icon-del'
    }.merge(options)

    link_to t(:button_delete), url, options
  end

  # Returns a h2 tag and sets the html title with the given arguments
  def title(*args)
    strings = args.map do |arg|
      if arg.is_a?(Array) && arg.size >= 2
        link_to(*arg)
      else
        h(arg.to_s)
      end
    end
    content_tag('h2', strings.join(' &#187; ').html_safe)
  end

  def error_messages_for(*objects)
    html = ""
    objects = objects.map {|o| o.is_a?(String) ? instance_variable_get("@#{o}") : o}.compact
    errors = objects.map {|o| o.errors.full_messages}.flatten
    if errors.any?
      html << "<div id='errorExplanation'><ul>\n"
      errors.each do |error|
        html << "<li>#{h error}</li>\n"
      end
      html << "</ul></div>\n"
    end
    html.html_safe
  end

  def labelled_form_for(*args, &proc)
    args << {} unless args.last.is_a?(Hash)
    options = args.last
    if args.first.is_a?(Symbol)
      options.merge!(:as => args.shift)
    end
    options.merge!({:builder => Railshier::Views::LabelledFormBuilder})
    form_for(*args, &proc)
  end

  def labelled_fields_for(*args, &proc)
    args << {} unless args.last.is_a?(Hash)
    options = args.last
    options.merge!({:builder => Railshier::Views::LabelledFormBuilder})
    fields_for(*args, &proc)
  end

  def calendar_for(field_id)
    javascript_tag("$(function() { $('##{field_id}').datepicker({dateFormat: 'yy-mm-dd'}); });")
  end

  # Renders flash messages
  def render_flash_messages
    s = ''
    flash.each do |k,v|
      s << content_tag('div', v.html_safe, :class => "flash #{k}", :id => "flash_#{k}")
    end
    s.html_safe
  end

end
