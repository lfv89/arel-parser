class Segmentation
  def initialize(name)
    @segment = name
  end

  def conditions
    SegmentParser.new(segment).parse
  end

  private

  def segment
    Segment.find_by!(name: @segment).data
  end
end
