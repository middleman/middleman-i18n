module Middleman
  module Features
    module I18n
      class << self
        def registered(app)
        end
        alias :included :registered
      end
    end
  end
end