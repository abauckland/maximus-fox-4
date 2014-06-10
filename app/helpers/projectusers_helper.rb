module ProjectusersHelper

  
  def  project_access(projectuser)  
      #list subsections that user has access to for project
      #if not subsections - user has access to whole project
      if projectuser.project.ref_system == "CAWS"
        subsection_array = Cawssubsection.joins(:subsections => :subsectionusers
                                    ).where('subsectionusers.projectuser_id' =>projectuser.id
                                    ).collect{|x| x.full_code}.uniq.sort.join(",")
      else
##uniclass query here        
      end  
            
      if subsection_array.length == 0
        return "All".html_safe 
      else  
        return subsections
      end 
  end
  
  
  def  last_seen(projectuser)
    if !projectuser.user.last_sign_in.blank?   
      projectuser.user.last_sign_in.strftime("%e %B %Y")
    else
      "n/a"
    end
  end

end
