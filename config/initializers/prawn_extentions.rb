require "prawn"

module Prawn
  module Text

    def draft_text_box(string, options)
      box = Text::Box.new(string, options.merge(:document => self)) 
      box.render(:dry_run => true)
      @draft_box_height = box.height
    end
    
    
    def spec_box(string, options)
      box = Text::Box.new(string, options.merge(:document => self)) 
      box.render(:dry_run => true)
      @box_height = box.height
      box.render
    end
       
    def draft_box_height
      @draft_box_height
    end
    
    def box_height
      @box_height
    end

  end
end
