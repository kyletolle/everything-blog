# Taken from https://stackoverflow.com/a/13916925/249218
RSpec::Matchers.define :have_constant do |const|
  match do |owner|
    owner.const_defined?(const)
  end
end
