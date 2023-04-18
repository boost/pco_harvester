# frozen_string_literal: true

module FormHelper
  def vertical_form_with(**options, &block)
    options.merge!(builder: VerticalFormBuilder)
    form_with(**options, &block)
  end
end
