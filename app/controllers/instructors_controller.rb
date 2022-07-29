class InstructorsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity_exception

  def index
    render json: Instructor.all
  end

  def create
    instructor = Instructor.create!(instructor_params)
    render json: instructor, status: :created
  end

  def show
    render json: get_instructor
  end

  def update
    get_instructor.update(instructor_params)
    if update
      render json: get_instructorq, status: :ok
    else  
      render json: { erroe: "Invalid data given" }, status: :forbidden
    end
  end

  def destroy
    get_instructor.destroy
    head :no_content
  end

  private

  def instructor_params
    params.permit(:name)
  end

  def get_instructor
    Instructor.find(params[:id])
  end

  def record_not_found
    render json: { error: "INstructor not found" }, status: :not_found
  end

  def unprocessable_entity_exception(exception)
    render json: { errors: exception.record.errors.full_messages}, status: :unprocessable_entity
  end
end
