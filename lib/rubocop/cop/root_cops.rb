require "rubocop"

require_relative "root_cops/eq_be_eql"
require_relative "root_cops/factories/factory_file_name"
require_relative "root_cops/factories/factory_name"
require_relative "root_cops/job_has_queue"
require_relative "root_cops/no_backfills_in_data_migration"
require_relative "root_cops/private_methods/called_private_method"
require_relative "root_cops/private_methods/called_protected"
require_relative "root_cops/private_methods/underscore_prefix"
require_relative "root_cops/raise_i18n"
require_relative "root_cops/retry_on_warning"
require_relative "root_cops/shared_context_name"
require_relative "root_cops/spec_file_name"
require_relative "root_cops/unnecessary_aggregate_failures"
require_relative "root_cops/use_before_action"
require_relative "root_cops/use_detect"
require_relative "root_cops/use_envvars"
require_relative "root_cops/use_lonely_operator"
require_relative "root_cops/envvar_assignment"
