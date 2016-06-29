class Search
  SEARCH_TYPES = %w(all answer question comment user)

  def self.query(search_query, search_type)
    types = SEARCH_TYPES
    return [] unless types.include? search_type
    @results = perform_search(search_query, search_type)
  end

  def self.perform_search(search_query, search_type)
    search_query = Riddle::Query.escape(search_query)
    if search_type == 'all'
      ThinkingSphinx.search(search_query)
    else
      search_type.underscore.classify.constantize.search(search_query)
    end
  end
end