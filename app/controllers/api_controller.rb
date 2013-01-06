class ApiController < ApplicationController
  def movies
    @movies = Movie.order('updated_at desc').limit(10)

      render json: @movies
  end
end
