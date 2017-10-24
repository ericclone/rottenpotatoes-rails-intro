class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.uniq.pluck(:rating)
    @order = params[:order]
    @order = session[:order] if not @order and session[:order]
    @ratings = params[:ratings]
    @ratings = session[:ratings] if (not @ratings or @ratings.empty?) and session[:ratings]
    @ratings = Hash[@all_ratings.map {|x| [x, 1]}] unless @ratings
    session[:ratings] = @ratings
    

    @movies = Movie.where(rating: @ratings.keys)
    if @order and ["title", "release_date"].include?(@order)
      @order = @order.to_sym
      session[:order] = @order
      @movies = @movies.order(@order)
    elsif @order
      redirect_to movies_path
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
