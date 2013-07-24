module ActiveAdmin
  module Views
    module Pages
      class Show < Base
        # Override the main_content method to additionally call the
        # hidden_span_for_commit_button_label method.
        #
        # Refer the link below for a technique used here to override a method.
        # Jay Fields' Thoughts: Ruby: Alias method alternative
        # http://blog.jayfields.com/2006/12/ruby-alias-method-alternative.html
        orig_main_content = self.instance_method(:main_content)
        define_method(:main_content) do
          orig_main_content.bind(self).call
          hidden_span_for_commit_button_label
        end

        protected
        def hidden_span_for_commit_button_label
          if params[:action] == 'validate'
            key = params[:_method] == 'put' ?
              "form.commit_update" : "form.commit_create"
            span I18n.t(key), :id => 'commit_button_label',
              :style => 'display:none'
          end
        end
      end
    end
  end
end
