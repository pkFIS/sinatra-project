class BuildEntriesController < ApplicationController

  get '/build_entries' do
    @build_entries = BuildEntry.all
    erb :'build_entries/index'
  end

  # get build_entries/new to render a form to create new entry
  get '/build_entries/new' do
    redirect_if_not_logged_in
    erb :'/build_entries/new'
  end

  # post build_entries to create a new build entry
  post '/build_entries' do
    binding.pry
    redirect_if_not_logged_in
    # I want to create a new build entry and save it to the DB
    # I also only want to create a build entry if a user is logged in
    # I only want to save the entry if it has some content
    if params[:content] != ""
      # create a new entry
      @build_entry = BuildEntry.create(content: params[:content], user_id: current_user.id, title: params[:title], mood: params[:mood])
      flash[:message] = "Build entry successfully created." if @build_entry.id
      redirect "/build_entries/#{@build_entry.id}"
    else
      flash[:errors] = "Something went wrong - you must provide content for your entry."
      redirect '/build_entries/new'
    end
  end

  # show route for a build entry
  get '/build_entries/:id' do
    set_build_entry
    erb :'/build_entries/show'
  end

  # This route should send us to build_entries/edit.erb, which will
  # render an edit form
  get '/build_entries/:id/edit' do
    redirect_if_not_logged_in
    set_build_entry
    if authorized_to_edit?(@build_entry)
      erb :'/build_entries/edit'
    else
      redirect "users/#{current_user.id}"
    end
  end

  # This action's job is to ...???
  patch '/build_entries/:id' do
    redirect_if_not_logged_in
    # 1. find the build entry
    set_build_entry
    if @build_entry.user == current_user && params[:content] != ""
    # 2. modify (update) the build entry
      @build_entry.update(content: params[:content])
      # 3. redirect to show page
      redirect "/build_entries/#{@build_entry.id}"
    else
      redirect "users/#{current_user.id}"
    end
  end

  delete '/build_entries/:id' do
    set_build_entry
    if authorized_to_edit?(@build_entry)
      @build_entry.destroy
      flash[:message] = "Successfully deleted that entry."
      redirect '/build_entries'
    else
      redirect '/build_entries'
    end
  end
  # index route for all build entries

  private

  def set_build_entry
    @build_entry = BuildEntry.find(params[:id])
  end
end
