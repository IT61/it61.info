class ErrorsController < ApplicationController
  def code_404
    render "not_found", status: :not_found
  end
end
