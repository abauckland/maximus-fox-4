require 'test_helper'

class ProductimportsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  def test_should_successfully_import_csv
    csv_rows = <<-eos
CAWS,Uniclass II,Product_ref,Manufacturer,subtitle,product ref,product name,item ref,item name,Type,Parent,Type,Size,Width,Length,Height,Freeze/Thaw Resistance,Active Soluble Salt Content ,Compressive Strength,Water Absorption (max)
,,,,,,,,,,,,mm,mm,mm,mm,,,N/mm2,%
,,,,,,,,,,,,,,,,BS EN 771 ,BS EN 771 ,,
F10.3110,,YORK-01-001-001-01-01,The York Handmade Brick Company Limited,Clay Facing Brick,na,Old Clamp,na,na,product,na,Handmade,215 x 102.5 x 50,102.5,215,50,F2,S2,17.6,18
F10.3110,,YORK-01-001-002-01-01,The York Handmade Brick Company Limited,Clay Facing Brick,na,Old Clamp,na,na,product,na,Handmade,215 x 102.5 x 65,102.5,215,65,F2,S2,17.6,18
eos

    file = Tempfile.new('new_products.csv')
    file.write(csv_rows)
    file.rewind

    sign_in users(:admin)

#    assert_difference "User.count", 3 do
      post :create, :csv => Rack::Test::UploadedFile.new(file, 'text/csv')
#    end

#    assert_redirected_to your_path
#    assert_equal "Successfully imported the CSV file.", flash[:notice]
  end

end
