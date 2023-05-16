# frozen_string_literal: true

module FormHelper
  def vertical_form_with(**options, &)
    options.merge!(builder: VerticalFormBuilder)
    form_with(**options, &)
  end

  def find_options_from_validations(model, attribute)
    model.validators_on(attribute).find { |validation| validation.options[:in].present? }
         .options[:in]
  end
end
