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
	 	byebug
		a = f.attachment.file.file
		n = a.length
		if a[n-3 .. n] == 'xls'
			ex = Roo::Excel.new("#{f.attachment.file.file}")
				byebug
				ex.default_sheet = ex.sheets[0] #Mention the sheet number
				2.upto(ex.last_column) do |col|
					title_head = ex.cell(col,2)
					price_head = ex.cell(col,3)
				end
				2.upto(ex.last_row) do |line| #start and end of row in which data is present
					byebug
					title = ex.cell(line,2)#the cell is in the format: cell(row X column)
					price = ex.cell(line,ex.last_column)
					byebug
					@product = Product.create(:title => title,:price => price)
					 @product.save!
					 flash[:success] = "data is stored successfully"
				end
		elsif a[n-3 .. n] == 'ods'
			ex = Roo::Openoffice.new("#{f.attachment.file.file}")
			byebug
			ex.default_sheet = ex.sheets[0] #Mention the sheet number
			2.upto(ex.last_row) do |line| #start and end of row in which data is present
				byebug
				title = ex.cell(line,2)#the cell is in the format: cell(row X column)
				price = ex.cell(line,ex.last_column)
				@product = Product.create(:title => title,:price => price)
			  @product.save!
			  flash[:success] = "data is stored successfully"
			end
		else	
			byebug
			ex.default_sheet = ex.sheets[0] #Mention the sheet number
			2.upto(ex.last_row) do |line| #start and end of row in which data is present
				byebug
				title = ex.cell(line,2)#the cell is in the format: cell(row X column)
				price = ex.cell(line,ex.last_column)
				@product = Product.create(:title => title,:price => price)
			end
   	end
  rescue ActiveRecord::RecordInvalid
 		flash[:alert] = "check datatypes of the columns"
   	render 'message'
	end
end
