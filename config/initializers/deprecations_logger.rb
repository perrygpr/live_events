# to log the deprecation warnings

DeprecationLogger = Logger.new(Rails.root.join('log/deprecations.log'))

ActiveSupport::Notifications.subscribe(/deprecation/) do |type, date,b,c, event|
  DeprecationLogger.info("#{date} - #{event[:message]}")
end