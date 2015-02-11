class CreatePrintsettings < ActiveRecord::Migration
  def change
    create_table :printsettings do |t|
      t.integer :project_id
      t.string :font_style
      t.string :font_size
      t.string :structure
      t.string :prelim
      t.string :page_number
      t.string :client_detail
      t.string :client_logo
      t.string :project_detail
      t.string :project_image
      t.string :company_detail
      t.string :header_project
      t.string :header_client
      t.string :header_document
      t.string :header_logo
      t.string :footer_detail
      t.string :footer_author
      t.string :footer_date
      t.string  :section_cover
      t.timestamps
    end
  end
end
