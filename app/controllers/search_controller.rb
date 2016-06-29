class SearchController < ApplicationController
  skip_after_action :verify_athorized

  def search
    @results = Search.query(params[:search_query], params[:search_type])
  end
end