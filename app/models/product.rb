class Product < ApplicationRecord
	validates :price, :numericality => { :only_integer => true }
end
