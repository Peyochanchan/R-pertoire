class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home poldeconf cgu]

  def home
    @lists = policy_scope(List)
    @songs = policy_scope(Song)
  end

  def poldeconf; end

  def cgu; end
end
