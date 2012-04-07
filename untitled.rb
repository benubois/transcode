require 'fssm'

FSSM.monitor('/Users/bb/Movies/', '**/*', :directories => true) do
  update do |base, relative|
	 puts "update #{base}"
	 puts "update #{relative}"
  end
  delete do |base, relative|
 	 puts "delete #{base}"
 	 puts "delete #{relative}"
  end
  create do |base, relative|
 	 puts "create #{base}"
 	 puts "create #{relative}"
  end
end

enque get info
enque encode