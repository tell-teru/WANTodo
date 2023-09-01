require 'bundler/setup'
Bundler.require

ActiveRecord::Base.establish_connection

class Count < ActiveRecord::Base
end

class Entry < ActiveRecord::Base
end

class User < ActiveRecord::Base
end