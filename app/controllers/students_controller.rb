class StudentsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity_exception

  def index
    render json: Student.all
  end

  def show
    render json: get_student
  end

  def create
    student = Student.create!(student_params)
    render json: student, status: :created
  end

  def update
    student = get_student.update(student_params)
    if student
      render json: get_student
    else  
      render json: { error: "Invalid credentials given" }, status: :forbidden
    end
  end

  def destroy
    get_student.destroy
    head :no_content
  end

  private

  def student_params
    params.permit(:name, :major, :age, :instructor_id)
  end

  def get_student
    Student.find(params[:id])
  end

  def record_not_found
    render json: { error: "Student not found" }, status: :not_found
  end

  def unprocessable_entity_exception(exception)
    render json: { errors: exception.errors.full_messages}, status: :unprocessable_entity
  end
end
