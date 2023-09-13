# frozen_string_literal: true

class VerticalFormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::OutputSafetyHelper # for #safe_join

  def errors(method)
    # errors from source or source_id are refering to the Source model
    errors = object.errors[method] + object.errors[method.to_s.gsub(/_id$/, '')]

    safe_join(errors.uniq.map do |error_msg|
      @template.tag.div(class: 'invalid-feedback') do
        error_msg
      end
    end)
  end

  def error_wrapper(method)
    yield + errors(method)
  end

  def modify_options(options)
    if options[:class].is_a? Hash
      options[:class]['is-invalid'] = true
    else
      options[:class] = "is-invalid #{options[:class]}"
    end

    options
  end

  ############################################
  # Overriding existing helpers              #
  ############################################
  %w[
    text_field
    text_area
    password_field
    search_field
    telephone_field
    date_field
    datetime_local_field
    month_field
    week_field
    url_field
    email_field
    color_field
    time_field
    number_field
    range_field
  ].each do |field_type|
    define_method(field_type) do |method, options = {}|
      disable_errors_display = options.delete(:disable_errors_display)

      return super(method, options) if disable_errors_display

      error_wrapper(method) do
        options = modify_options(options) if @object.errors[method].any?
        super(method, options)
      end
    end
  end
end
