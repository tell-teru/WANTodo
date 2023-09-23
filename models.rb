require 'bundler/setup'
Bundler.require

ActiveRecord::Base.establish_connection

class Count < ActiveRecord::Base
end

class Entry < ActiveRecord::Base
end

class User < ActiveRecord::Base
    has_secure_password
    has_many :wants
    
    validates :name,
        presence: true
    validates :password,
        length: { in: 3..10}
end

class Want < ActiveRecord::Base
    belongs_to :user
    belongs_to :group
    belongs_to :genre
end

class Group < ActiveRecord::Base
    has_many :wants
end

class Part < ActiveRecord::Base
end

class Term < ActiveRecord::Base
end

class Genre < ActiveRecord::Base
    has_many :wants
end