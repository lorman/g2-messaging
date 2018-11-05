module Messaging
  # Railtie to hook into Rails.
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load 'g2/messaging/tasks/run.rake'
    end
  end
end
