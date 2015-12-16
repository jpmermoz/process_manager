class TasksController < ApplicationController
  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all

    # filter by status
    @tasks = @tasks.select { |t| t.stat.include?(params[:status]) } if params[:status].present?

    # filter by user
    @tasks = @tasks.select { |t| t.user.include?(params[:user]) } if params[:user].present?

    # filter by cpu usage less or equals than
    @tasks = @tasks.select { |t| t.cpu.to_f <= params[:cpu_lteq].to_f } if params[:cpu_lteq].present?

    # filter by cpu usage greater or equals than
    @tasks = @tasks.select { |t| t.cpu.to_f >= params[:cpu_gteq].to_f } if params[:cpu_gteq].present?

    # filter by memory usage less or equals than
    @tasks = @tasks.select { |t| t.mem.to_f <= params[:mem_lteq].to_f } if params[:mem_lteq].present?

    # filter by memory usage greater or equals than
    @tasks = @tasks.select { |t| t.mem.to_f >= params[:mem_gteq].to_f } if params[:mem_gteq].present?

    # filter by rss less or equals than
    @tasks = @tasks.select { |t| t.rss.to_f <= params[:rss_lteq].to_f } if params[:rss_lteq].present?

    # filter by rss greater or equals than
    @tasks = @tasks.select { |t| t.rss.to_f >= params[:rss_gteq].to_f } if params[:rss_gteq].present?

    render json: @tasks
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @task = Task.find(params[:id])
    render json: @task
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(params[:task])

    if @task.save
      render json: @task, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    @task = Task.find(params[:id])

    if @task.update(params[:task])
      render json: @task, status: :accepted
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task = Task.find(params[:id])
    
    if @task.destroy
      head :no_content
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end
end
