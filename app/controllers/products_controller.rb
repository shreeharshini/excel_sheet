class ProductsController < ApplicationController
  def index
	  @products = Product.order('created_at DESC')
	  @resumes = Resume.all
	  respond_to do |format|
		   format.html
			 format.xlsx 
	 	end
	end
	
	def message
	end
	
	def  fetch_excel_data
	  f = Resume.last
		a = f.attachment.file.file
		n = a.length
		if a[n-3 .. n] == 'xls'
			Product.transaction do
				ex = Roo::Excel.new("#{f.attachment.file.file}")
				ex.default_sheet = ex.sheets[0] #Mention the sheet number of excel workbook
				results = []
				2.upto(ex.last_row) do |line| #start and end of row in which data is present
					title = ex.cell(line,2)#the cell is in the format: cell(row X column)
					price = ex.cell(line,ex.last_column)
					@product = Product.create(:title => title,:price => price)
					if @product.errors.any?
						 results << @product.errors.full_messages << @product.inspect
						flash[:alert] = "the errors and their resp. records are:#{results.flatten}"
					byebug
					end
					 flash[:success] = "data is stored successfully"
				end
				if @product.errors.any?	#this is used to rollback transaction only when error occur		
			  	raise ActiveRecord::Rollback #used to rollback the entire transaction
				end
			end
   	end
  end
end
