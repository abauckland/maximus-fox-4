class CreatePrintsettings < ActiveRecord::Migration
  def change
    create_table :printsettings do |t|
      t.integer :project_id
      t.integer :font_style
      t.integer :font_size
      t.integer :structure
      t.integer :prelim
      t.integer :page_number
      t.integer :client_detail
      t.integer :client_logo
      t.integer :project_detail
      t.integer :project_image
      t.integer :company_detail
      t.integer :header_project
      t.integer :header_client
      t.integer :header_document
      t.integer :header_logo
      t.integer :footer_detail
      t.integer :footer_author
      t.integer :footer_date
      t.string  :section_cover
      t.timestamps
    end
  end
end
