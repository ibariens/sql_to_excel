class CustomVariablesController < ApplicationController
  before_filter :authenticate_user
  def create   # /reports POST
    @cv = CustomVariable.new(cv_params)
    if @cv.valid?
      @cv.save
      flash[:notice] = 'Custom Variable was successfully updated.'
      redirect_to @cv
    end
  end

  def index  # /reports INDEX
    @cvs = CustomVariable.all
  end

  def show  # /reports/:id   # GET
    @cv = CustomVariable.find(params[:id])
  end

  def edit # PUT & PATCH
    @cv = CustomVariable.find(params[:id])
  end

  def update
    @cv = CustomVariable.find(params[:id])
    if @cv.update(cv_params)
      flash[:notice] = 'Profile was successfully updated.'
      redirect_to(@cv)
    else
      render "edit"
    end
  end

  def new # GET
    @cv = CustomVariable.new
  end

  def destroy  # DELETE
    @cv = CustomVariable.find(params[:id])
    if @current_user.is_admin?
      @cv.destroy
    else
      flash[:error] = "You're not allowed to delete this report."
    end

    redirect_to action: "index"
  end

  def select # custom get
    @report = Report.find(params[:report_id]) || raise("No report found")
    @cvs = @report.fetch_custom_variables
  end


  private
  def cv_params
    params.require(:custom_variable).permit(:name, :stored_sql)
  end
end
