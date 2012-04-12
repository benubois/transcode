require 'fssm'

FSSM.monitor('/Users/bb/Movies/', '*', :directories => true) do
  create do |base, relative|
 	 puts "create #{base}"
 	 puts "create #{relative}"
  end
end