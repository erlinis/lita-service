# frozen_string_literal: true
require 'lita'

Lita.load_locales Dir[File.expand_path(
  File.join('..', '..', 'locales', '*.yml'), __FILE__
)]

require 'terminal-table'
require 'lita/handlers/service'
require 'lita/handlers/customer'
require 'lita/interactors/base_interactor'
require 'lita/interactors/list_services'
require 'lita/interactors/create_service'
require 'lita/interactors/show_service'
require 'lita/interactors/delete_service'
require 'lita/interactors/inscribe_customer'
require 'lita/interactors/change_value'
require 'lita/interactors/add_quantity'
require 'lita/interactors/reset_quantity'
require 'lita/interactors/add_all'
require 'lita/interactors/delete_customer'
require 'lita/helpers/messages_helper'
require 'lita/helpers/last_update_helper'

Lita::Handlers::Service.template_root File.expand_path(
  File.join('..', '..', 'templates'),
  __FILE__
)
