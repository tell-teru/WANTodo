require 'bundler/setup'
Bundler.require

ActiveRecord::Base.establish_connection

class Count < ActiveRecord::Base
end

class Entry < ActiveRecord::Base
end

class User < ActiveRecord::Base
    has_secure_password
    validates :name,
        presence: true
    validates :password,
        length: { in: 3..10}
end

class Want < ActiveRecord::Base
end

class Group < ActiveRecord::Base
end

class Part < ActiveRecord::Base
end

class Term < ActiveRecord::Base
end

class Genre < ActiveRecord::Base
end