module ApplicationHelper
  def flash_class_for flash_type
    case flash_type
    when 'success' then 'alert-success'
    when 'error'   then 'alert-danger'
    when 'alert'   then 'alert-warning'
    when 'notice'  then 'alert-info'
    end
  end

  # controller名とaction名による条件分岐
  def controller_action?(ctr_name, action_name)
    controller.controller_name == ctr_name && controller.action_name == action_name
  end
end
