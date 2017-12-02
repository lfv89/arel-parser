class SegmentParser
  def initialize(segment)
    @segment, @data = segment, segment.data
    include_matchers && build_matchers
  end

  def parse
    parse_segment_data
  end

  private

  def include_matchers
    matcher = "#{@segment.segmented}NodeMatchers"
    self.class.include(matcher.constantize)
  end

  def parse_segment_data
    @data.inject(parse_fragment(@data.pop)) do |node, fragment|
      node.or(parse_fragment(fragment))
    end
  end

  def parse_fragment(fragment)
    fragment.inject(parse_sub_fragment(*fragment.shift)) do |node, sub_fragment|
      node.and(parse_sub_fragment(*sub_fragment))
    end
  end

  def parse_sub_fragment(field, value)
    if range_match?(field)
      return range_node_matcher(field, value)
    elsif exact_match?(field)
      return equal_node_matcher(field, value)
    elsif association_match?(field)
      return association_node_matcher(field, value)
    end
  end

end
