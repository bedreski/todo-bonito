# frozen_string_literal: true

class TaskMailer < ApplicationMailer
  def task_completed_notification
    task = params[:task]

    mail(to: task.user.email, subject: 'Task completed notification') do |format|
      format.text { render(plain: "Task \"#{task.name}\" completed!") }
    end
  end
end
