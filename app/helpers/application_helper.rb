module ApplicationHelper
  def comment_status_class(status)
    case status
    when "pending"
      "text-yellow-400"
    when "approved"
      "text-green-500"
    when "rejected"
      "text-red-600"
    else
      ""
    end
  end
end
