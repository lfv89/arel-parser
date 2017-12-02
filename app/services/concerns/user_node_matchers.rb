module UserNodeMatchers
  def build_matchers
    %i[tags users tags_users].each do |relation|
      instance_variable_set("@#{relation}", Arel::Table.new(relation))
    end
  end

  def range_match?(field)
    User.date_field?(field.to_s) || User.datetime_field?(field.to_s)
  end

  def exact_match?(field)
    User.string_field?(field.to_s) || User.boolean_field?(field.to_s)
  end

  def association_match?(field)
    User.has_association?(field)
  end

  def equal_node_matcher(field, value)
    @users[field].eq(value)
  end

  def range_node_matcher(field, value)
    @users[field].gteq(value.first).and(@users[field].lteq(value.last))
  end

  def association_node_matcher(field, value)
    @users[:id].in(
      @users.project(@users[:id])
           .join(@tags_users)
           .on(@users[:id].eq(@tags_users[:user_id]))
           .join(@tags)
           .on(@tags_users[:tag_id].eq(@tags[:id]))
           .where(@tags[:name].in(value))
    )
  end
end
