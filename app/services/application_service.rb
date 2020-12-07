# frozen_string_literal: true

# Syntactic sugar to facilitate services call
class ApplicationService
  def self.call(*args, &block)
    new(*args, &block).call
  end
end
