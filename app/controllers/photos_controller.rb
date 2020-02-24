class PhotosController < ApplicationController

  def index
    render({ :template => "photo_templates/index.html.erb"})
  end

end 
