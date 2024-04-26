# Include modules and add methods that are for all API requests
abstract class HtmxAction < Lucky::Action
  accepted_formats [:html], default: :html

  route_prefix "/htmx/v1"
end
