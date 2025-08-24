# Prevent Rails from injecting <div class="field_with_errors"> wrappers
# so we can control styles ourselves with Tailwind.
ActionView::Base.field_error_proc = proc { |html_tag, _| html_tag.html_safe }