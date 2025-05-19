# This initializer fixes an incompatibility with the YAML parser `psych`.
# It can be removed when the Rails version is >= 7.0.3.1.
#
# See:
# - https://stackoverflow.com/a/71192990
# - https://discuss.rubyonrails.org/t/cve-2022-32224-possible-rce-escalation-bug-with-serialized-columns-in-active-record/81017
#
# NOTE: Remove this initializer when Rails is >= 7.0.3.1
module YAML
  class << self
    alias_method :load, :unsafe_load if YAML.respond_to? :unsafe_load
  end
end
