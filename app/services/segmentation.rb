class Segmentation
  def initialize(slug)
    @slug = slug
  end

  def load
    segment.segmented.where(parse)
  end

  private

  def parse
    SegmentParser.new(segment).parse
  end

  def segment
    @segment ||= Segment.find_by!(slug: @slug)
  end
end
