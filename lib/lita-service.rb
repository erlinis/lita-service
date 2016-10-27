require 'lita'

Lita.load_locales Dir[File.expand_path(
  File.join('..', '..', 'locales', '*.yml'), __FILE__
)]

require 'lita/handlers/service'
require 'lita/interactors/base_interactor'
require 'lita/interactors/create_service'

Lita::Handlers::Service.template_root File.expand_path(
  File.join('..', '..', 'templates'),
  __FILE__
)