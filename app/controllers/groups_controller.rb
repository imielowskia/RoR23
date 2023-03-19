class GroupsController < ApplicationController
  before_action :set_group, only: %i[ show edit update destroy grade gradesave ]

  # GET /groups or /groups.json
  def index
    @groups = Group.all
  end

  # GET /groups/1 or /groups/1.json
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  #metoda oceniania w grupie
  def grade
    @course = Course.find(params[:course_id])
    @students = Student.where(group_id: @group.id).all
    @oceny = []
    @students.each do |s|
      if CourseStudent.where(student_id: s.id, course_id: @course.id).any?
        cs = CourseStudent.find_by(student_id: s.id, course_id: @course.id)
        @oceny[s.id] = cs.ocena
      else
        CourseStudent.create(student_id: s.id, course_id: @course.id, ocena: 0)
        @oceny[s.id] = 0
      end
    end
  end

  def gradesave
    @course = Course.find(params[:course_id])
    @students = Student.where(group_id: @group.id).all

    @students.each do |s|
      s.courses.destroy(@course.id)
      ocena = params['oceny_'+s.id.to_s].to_i
      cs = CourseStudent.new(course_id: @course.id, student_id: s.id, ocena: ocena)
      cs.save!
    end
    redirect_to group_path(@group.id), notice: "Zapisano oceny"
  end

  # POST /groups or /groups.json
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to groups_url(@group), notice: "Group was successfully created." }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1 or /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to group_url(@group), notice: "Group was successfully updated." }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1 or /groups/1.json
  def destroy
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url, notice: "Group was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def group_params
      params.require(:group).permit(:nazwa, course_ids: [])
    end
end
