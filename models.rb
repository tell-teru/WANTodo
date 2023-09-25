require 'bundler/setup'
Bundler.require

ActiveRecord::Base.establish_connection

# class Count < ActiveRecord::Base
# end

# class Entry < ActiveRecord::Base
# end

class User < ActiveRecord::Base
    has_secure_password
    has_many :wants
    
    has_many :groups, :through => :parts
    
    validates :name,
        presence: true
    validates :password,
        length: { in: 3..10}
end

class Want < ActiveRecord::Base
    belongs_to :user
    belongs_to :group
    belongs_to :genre
    
    validates :title,
        presence: true

end

class Group < ActiveRecord::Base
    has_secure_password
    has_many :wants
    
    has_many :users, :through => :parts
    
    validates :name,
        presence: true
end

class Part < ActiveRecord::Base
    belongs_to :user
    belongs_to :group
end

class Term < ActiveRecord::Base
end

class Genre < ActiveRecord::Base
    has_many :wants
end