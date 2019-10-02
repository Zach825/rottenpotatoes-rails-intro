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
    @all_ratings = Movie.all_ratings
    need_redirect = false 
    
    @sort_method = params[:sort_by] #sort_method used to remember if the page is currently sorting by title or release date
    if(@sort_method == nil) #nil used for default
      @sort_method = session[:sort_by]
      if(@sort_method == nil)
        @sort_method = "title"
        session[:sort_by] = @sort_method
      end
      need_redirect = true
    else
      session[:sort_by] = @sort_method
    end
    
    
    @selected_ratings = params[:ratings] #sorts movies based on ratings selected
    if(@selected_ratings == nil || @selected_ratings.empty?)
      @selected_ratings = session[:ratings]
      if(@selected_ratings == nil) # if not yet stored in session
        @selected_ratings = @all_ratings
        session[:ratings] = @selected_ratings
      end
      need_redirect = true
    else
      if(@selected_ratings.kind_of?(Hash))
        @selected_ratings = @selected_ratings.keys
      end
      session[:ratings] = @selected_ratings
    end
    if need_redirect
      flash.keep
      redirect_to movies_path(:sort_by => @sort_method, :ratings => @selected_ratings)
    end
    
    if @sort_method == "title"
      @movies = Movie.where(["rating IN (?)", @selected_ratings]).order("title ASC")
    elsif @sort_method == "release_date"
      @movies = Movie.where(["rating IN (?)", @selected_ratings]).order("release_date ASC")
    else # Then using unknown sort method
      @movies = Movie.all
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
