class SegmentParser
  include NodeMatchers

  def initialize(segment)
    @segment = segment
    @segmented = :user
  end

  def parse
    @segment.inject(parse_fragment(@segment.pop)) do |node, fragment|
      node.or(parse_fragment(fragment))
    end
  end

  private

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
