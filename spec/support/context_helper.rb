shared_context 'helper' do

  def do_not_follow_redirect &block
    begin
      options = page.driver.instance_variable_get(:@options)
      prev_value = options[:follow_redirects]
      options[:follow_redirects] = false
      yield
    ensure
      options[:follow_redirects] = prev_value
    end
  end

  def apply_count_option(attrs_set, options)
    if options.key? :count
      count_set = Array.new(options[:count]) { Hash.new }
      attrs_set = (attrs_set + count_set).first(options[:count])
    end
    attrs_set
  end

end
