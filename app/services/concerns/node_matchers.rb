module NodeMatchers
  def segmented
    @segmented.to_s.classify.constantize
  end

  def range_match?(field)
    date_field?(field.to_s) || datetime_field?(field.to_s)
  end

  def exact_match?(field)
    string_field?(field.to_s) || boolean_field?(field.to_s)
  end

  def association_match?(field)
    segmented.reflect_on_association(field).present?
  end

  def equal_node_matcher(field, value)
    users[field].eq(value)
  end

  def range_node_matcher(field, value)
    users[field].gteq(value.first).and(users[field].lteq(value.last))
  end

  def association_node_matcher(field, value)
    users[:id].in(
      users.project(users[:id])
           .join(tags_users)
           .on(users[:id].eq(tags_users[:user_id]))
           .join(tags)
           .on(tags_users[:tag_id].eq(tags[:id]))
           .where(tags[:name].in(value))
    )
  end

  %i[string date boolean datetime].each do |type|
    define_method("#{type}_field?") do |field|
      segmented.type_for_attribute(field.to_s).type == type
    end
  end

  %i[tags users tags_users].each do |relation|
    define_method(relation) do
      instance_variable_set("@#{relation}", Arel::Table.new(relation))
    end
  end
end
