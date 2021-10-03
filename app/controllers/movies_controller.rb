class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    
    @ratings_to_show_hash = params[:ratings] if params[:ratings]
    @title = params[:title] if params[:title]

    set_session(@title, @ratings_to_show_hash)

    if !@ratings_to_show_hash || !@title
      @ratings_to_show_hash =  get_selected_ratings() unless @ratings_to_show_hash
      @title = get_title() unless @title
      # redirect back to the index with the appropriate variables in the params hash
      redirect_to movies_path({ratings: @ratings_to_show_hash, title: @title}) 
    end

    @movies = Movie.sort_and_filter(@title, @ratings_to_show_hash)
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
