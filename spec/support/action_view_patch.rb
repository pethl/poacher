# spec/support/action_view_patch.rb
require 'action_view'

module ActionView
  module Template::Handlers
    class ERB
      ENCODING_FLAG = '-'.freeze unless defined?(ENCODING_FLAG)
    end
  end
end