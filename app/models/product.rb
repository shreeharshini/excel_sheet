class Product < ApplicationRecord
	validates :price, :numericality => { :only_integer => true }
	validates_uniqueness_of :title
end
