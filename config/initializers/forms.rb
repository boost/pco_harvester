# https://stackoverflow.com/a/5268106/2420710
# to avoid fields to be surrounded by ".field_with_errors" which
# messes up the bootstrap CSS
Rails.application.configure do
  config.action_view.field_error_proc = proc do |html_tag|
    html_tag
  end
end
