def watermark_helper(watermark, superseded, pdf)
  if watermark[0].to_i == 1
      pdf.transparent(0.15) do
        pdf.text_box "not for issue", :width => 250.mm, :size => 108, :style => :bold, :at => [20.mm,55.mm], :rotate => 60
      end
  end
  if superseded[0].to_i == 1
      pdf.transparent(0.15) do
        pdf.text_box "superseded", :width => 250.mm, :size => 108, :style => :bold, :at => [20.mm,55.mm], :rotate => 60
      end
  end  
end