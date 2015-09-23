class ReportsController < ApplicationController
  before_filter :authenticate_user
  def create   # /reports POST
    @report = Report.new(report_params)
    if @report.valid?
      flash[:notice] = 'Report was successfully updated.'
      @report.save!
      redirect_to @report
    end
  end

  def index  # /reports INDEX
    @reports = Report.for_user(@current_user.id)
    @groups  = Group.all
    @reports_without_group_with_owner    = Report.without_group_with_owner(@current_user.id)
    @reports_without_group_without_owner = Report.without_group_without_owner(@current_user.id)
  end

  def edit
    @report = Report.for_user(@current_user.id).find(params[:id])
  end

  def update
    @report = Report.for_user(@current_user.id).find(params[:id])
    if @report.update(report_params)
      flash[:notice] = 'Profile was successfully updated.'
      redirect_to(@report)
    else
      render "edit"
    end
  end

  def show # /reports/:id # GET
    @report = Report.for_user(@current_user.id).find(params[:id])
  end

  def execute # custom get
    @report = Report.for_user(@current_user.id).find(params[:id])
    if @report
      if @report.has_custom_variables && !@report.current_user_only?
        return redirect_to select_custom_variables_path(:report_id => @report)
      else
        custom_sql = @report.fill_custom_variables(params.merge(:current_user => [@current_user.id.to_s]))
        Resque.enqueue(Downloader, @report.id, @current_user.id, custom_sql)
        flash[:notice] = "Report is being executed please wait and press F5 to see if the report is finished"
      end
    else
      flash[:error] = "You're not allowed to execute this report."
    end

    redirect_to action: "index"
  end

  def destroy
    # does not actually delete the report, but clears the owners + groups
    report = Report.for_user(@current_user.id).find(params[:id])
    report.groups.delete_all
    report.owners.delete_all
    report.save!
    redirect_to action: "index"
  end

  def custom_execute # custom post, this is called after the custom selection form.
    @report = Report.for_user(@current_user.id).find(params[:id])
    custom_sql = @report.fill_custom_variables(params.merge(:current_user => [@current_user.id.to_s]))
    Resque.enqueue(Downloader, @report.id, @current_user.id, custom_sql)
    flash[:notice] = "Report with custom variables is being executed please wait and press F5 to see if the report is finished"
    redirect_to action: "index"
  end


  def download
    report = Report.for_user(@current_user.id).find(params[:id])
    if report && report.last_file_for_user(@current_user.id)
     file = report.last_file_for_user(@current_user.id).path_to_file
      send_file(file)
    else
      flash[:error] = "You're not allowed to delete this report."
    end
  end

  private
  def report_params
    params.require(:report).permit(:name, :stored_sql, :file_name, :users => [], :groups => [])
  end
end
