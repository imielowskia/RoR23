class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update destroy grade grade_student grade_group grade_group_save]

  # GET /courses or /courses.json
  def index
    @courses = Course.all
  end

  # GET /courses/1 or /courses/1.json
  def show
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  #GET /courses/1/group/1 metoda do oceniania grupy z przedmiotu
  def grade
    @group = Group.find(params[:group_id])
    @students = Student.where(group_id: @group.id).all
  end

  #GET /courses/1/group/1/student/1
  def grade_student
    @group = Group.find(params[:group_id])
    @student = Student.find(params[:student_id])
    @grades = Grade.where(course_id: @course.id, student_id: @student.id).all
    @grade = Grade.new
  end

  def grade_student_save
    group_id = params['group_id'].to_i
    grade = Grade.new
    grade.course_id = params['id'].to_i
    grade.student_id= params['student_id'].to_i
    grade.ocena = params['grade']['ocena'].to_f
    grade.data = DateTime.parse(params['grade']['data'])
    grade.save
    redirect_to grade_course_student_path(grade.course_id, group_id, grade.student_id )
  end

  # druga wersja oceniania - formularz całej grupy
  def grade_group
    @lista = {}
    @group = Group.find(params[:group_id])
    @group.students.each do |s|
      @lista[s.id]={'in'=>s.i_n, 'o'=>[] }
      s.grades.where(course_id: @course.id).each do |g|
        @lista[s.id]['o'].push({'data'=>g.data, 'ocena'=>g.ocena, 'id'=>g.id})
      end
    end
  end

  def grade_group_save
    @group = Group.find(params[:group_id])
    xdata = DateTime.now
    lista = params['o']
    lista.each_key do |s|
      sid = s.to_i
      lista[s].each_key do |g|
        gid = g.to_i
        xocena = lista[s][g].to_f
        xgr = Grade.find(gid)
        if xgr.ocena!=xocena
          xgr.ocena = xocena
          xgr.data = xdata
          xgr.save
        end
      end
    end
    redirect_to courses_url
  end

  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to courses_url, notice: "Course was successfully created." }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to courses_url, notice: "Course was successfully updated." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url, notice: "Course was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:nazwa)
    end
end
