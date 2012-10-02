module Prawnto
  module TemplateHandlers
    class Dsl < Base
      def self.call(template)
        <<-RUBY
          _prawnto_compile_setup(true)
          pdf = Prawn::Document.new(@prawnto_options[:prawn])
          #{SILENT_PRINT_CODE}
          pdf.extend ActionView::Helpers::TextHelper
          controller.instance_variables.each do |ivar| 
            pdf.instance_variable_set ivar, controller.instance_variable_get(ivar)
          end
          pdf.instance_eval do
            #{template.source}
          end
          pdf.render
        RUBY
      end
    end
  end
end


