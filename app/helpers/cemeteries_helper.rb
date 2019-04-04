module CemeteriesHelper
  def formatted_last_inspection(cemetery)
    if cemetery.last_inspection_date
      output = cemetery.last_inspection_date
      output << " (#{link_to 'view', show_inspection_cemetery_path(date: cemetery.last_inspection)})" if cemetery.last_inspection
    else
      output = 'No inspection recorded'
    end

    output
  end
end
