class Admin::QuizQuestionsController < Admin::AdminController
  before_action :authenticate_user!
  layout "admin"

  def index
    @questions = QuizQuestion.all.paginate(page: params[:page], per_page: 20).order(created_at: :desc)
  end

  def show
    @question = QuizQuestion.find_by(id: params[:id])
  end

  def new
    @question = QuizQuestion.new
  end

  def create
    @question = QuizQuestion.new(quiz_question_params)
    if @question.save
      redirect_to admin_quiz_questions_path
    else
      render :new
    end
  end

  def edit
    @question = QuizQuestion.find_by(id: params[:id])
  end

  def update
    @question = QuizQuestion.find_by(id: params[:id])
    if @question.update(quiz_question_params)
      redirect_to admin_quiz_questions_path
    else
      render :edit
    end
  end

  def destroy
    @question = QuizQuestion.find_by(id: params[:id])
    @question.destroy
    redirect_to admin_quiz_questions_path
  end

  def products
    @products = Product.where(QuizQuestion_id: params[:id]).paginate(page: params[:page], per_page: 20).order(created_at: :desc)
  end

  private

  def quiz_question_params
    params.require(:quiz_question).permit(:question, :option1, :option2, :option3, :option4, :correct_answer)
  end
end
