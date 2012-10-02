require "prawnto/available_features"

module Prawnto
  module TemplateHandlers
    class Base < (base_class_for_template_handler_required? ? ::ActionView::TemplateHandler : ::Object)
      include ::ActionView::TemplateHandlers::Compilable if template_should_include_compilable?

      SILENT_PRINT_CODE = %{
        if @prawnto_options[:silent_print]
          script = <<-EOF
            if (typeof JSSilentPrint == "undefined")
              this.print({bUI: true, bSilent: true, bShrinkToFit: false});
            else
              JSSilentPrint(this);
          EOF
          pdf.add_docopen_js 'Silent', script
        end
      }

      def self.call(template)
        "_prawnto_compile_setup;" +
        "pdf = Prawn::Document.new(@prawnto_options[:prawn]);" +
        "#{SILENT_PRINT_CODE}\n" +
        "#{template.source}\n" +
        "pdf.render;"
      end

      unless template_has_class_level_call_method?
        def compile(template)
          self.class.call(template)
        end
      end
    end
  end
end


