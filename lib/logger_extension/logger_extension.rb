# frozen_string_literal: true

module LoggerExtension
  def log_exception(exception)
    message = "Exception catched!\n"
    message += "Exeption type: #{exception.class.name}\n"
    message += "Exeption message: #{exception.message}\n"
    message += "~~~~~~~Stack trace~~~~~~~\n"
    exception.backtrace.each { |line| message += "#{line}\n" }
    message += '~~~~~~~~~~~~~~~~~~~~~~~~~'
    Rails.logger.error message
  end

  def log_errors(object)
    return if object.errors.empty?

    message = "Found errors during #{object.class.name} object manipulation\n"
    object.errors.full_messages.each { |m| message += "#{m}\n" }
    Rails.logger.error message
  end
end
