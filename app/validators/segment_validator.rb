class SegmentValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    @object = object
    @segment = value

    return @object.errors[attribute] << I18n.t(:blank, scope: %i[errors messages]) if value.blank?
    return @object.errors[attribute] << I18n.t(:format, scope: %i[errors messages segment]) unless value.all? { |v| v.is_a?(Hash) }
    return @object.errors[attribute] << I18n.t(:presence, scope: %i[errors messages segment]) if value.reject(&:empty?).empty?
    return @object.errors[attribute] << I18n.t(:reflection, scope: %i[errors messages segment]) if any_invalid_fragment?
  end

  private

  def segmented
    @object.segmented.to_s.classify.constantize
  end

  def any_invalid_fragment?
    @segment.inject(&:merge).keys.any? { |fragment| invalid_fragment?(fragment) }
  end

  def invalid_fragment?(fragment)
    !segmented.has_column?(fragment) && !segmented.has_association?(fragment)
  end
end
