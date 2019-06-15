require 'behaves/version'
require 'set'

module Behaves
  def implements(*methods)
    @behaviors ||= Set.new(methods)
  end

  def behaves_like(klass)
    at_exit { check_for_unimplemented(klass) }
  end

  private

  def check_for_unimplemented(klass)
    required = defined_behaviors(klass)

    implemented = Set.new(self.instance_methods - Object.instance_methods)

    unimplemented = required - implemented

    return if unimplemented.empty?

    raise NotImplementedError, "Expected `#{self}` to behave like `#{klass}`, but `#{unimplemented.to_a.join(', ')}` are not implemented."
  end

  def defined_behaviors(klass)
    if behaviors = klass.instance_variable_get("@behaviors")
      behaviors
    else
      raise NotImplementedError, "Expected `#{klass}` to define behaviors, but none found."
    end
  end
end
