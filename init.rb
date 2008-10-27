require 'growlr'

ActionView::Base.send :include, Growlr
ActionController::Base.send :include, Growlr