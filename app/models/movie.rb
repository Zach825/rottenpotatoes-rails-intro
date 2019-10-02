class Movie < ActiveRecord::Base
    def self.all_ratings #all_ratings defined to allow checkboxes to be created/used
		['G', 'PG', 'PG-13', 'R']
    end
end
