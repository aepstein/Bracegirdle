class CemeteryInspectionReportPdf
  include Prawn::View

  def initialize(params, **options)
    @params = params
    @options = options

    font_size 10

    content
  end

  def content
    font 'Arial'

    bounding_box [bounds.left, bounds.top], width: bounds.width do
      image Rails.root.join('app', 'javascript', 'images', 'cemeteries-logo.jpg'), height: 55, width: 193
    end

    bounding_box [bounds.right - 193, bounds.top - 20], width: bounds.width do
      text 'Field Inspection Report', size: 18
    end

    # Cemetery information
    move_down 20
    table(
      [
        [smallcaps('1. Cemetery'), smallcaps('County'), smallcaps('Number')],
        [@params[:inspection].cemetery.name, @params[:inspection].cemetery.county_name, @params[:inspection].cemetery.cemetery_id],
        [smallcaps('2. Interviewee'), smallcaps('Title'), smallcaps('Date')],
        [@params[:inspection].trustee_name, POSITIONS[@params[:inspection].trustee_position], @params[:inspection].date_performed],
        [{ content: smallcaps('3. Interviewee Address'), colspan: 2 }, smallcaps('Telephone Number')],
        [{ content: "#{@params[:inspection].trustee_street_address}, #{@params[:inspection].trustee_city}, #{@params[:inspection].trustee_state} #{@params[:inspection].trustee_zip}", colspan: 2 }, @params[:inspection].trustee_phone.presence || '---'],
        [{ content: smallcaps('4. Location of Cemetery'), colspan: 2 }, smallcaps('Email Address')],
        [{ content: @params[:inspection].cemetery_location, colspan: 2 }, @params[:inspection].trustee_email.presence || '---'],
        [{ content: smallcaps('5. Sign'), colspan: 3 }],
        [{ content: @params[:inspection].cemetery_sign_text, colspan: 3 }]
      ],
      cell_style: { inline_format: true },
      column_widths: [bounds.width / 2, bounds.width / 4, bounds.width / 4],
      width: bounds.width) do
        rows([0, 2, 4, 6, 8]).padding = [0, 0, 0, 0]
        rows([0, 2, 4, 6, 8]).borders = [:top]
        rows([0, 2, 4, 6, 8]).size = 8

        rows([1, 3, 5, 7, 9]).borders = []
        row(7).height = 31.74 if row(7).height < 31.74
    end
    stroke_horizontal_rule
    move_down 10
    stroke_horizontal_rule

    # Physical attributes
    table(
      [
        [{ content: '', colspan: 3 }, 'REMARKS'],
        ['6. Sign displayed (19 NYCRR §201.7)', "#{smallcaps('yes')}", smallcaps('no'), @params[:inspection].sign_comments],
        ['7. Administrative offices', "#{smallcaps('yes')}", smallcaps('no'), @params[:inspection].offices_comments],
        ['8. Rules and regulations conspicuously displayed', smallcaps('yes'), smallcaps('no'), @params[:inspection].rules_displayed_comments],
        ['9. Service charges and lot prices conspicuously displayed', "#{smallcaps('yes')}", smallcaps('no'), @params[:inspection].prices_displayed_comments],
        ['10. Scattering gardens', "#{smallcaps('yes')}", smallcaps('no'), @params[:inspection].scattering_gardens_comments],
        ['11. Community mausoleum', "#{smallcaps('yes')}", smallcaps('no'), "<font size='8'>#{smallcaps('Condition')}</font><br />#{Prawn::Text::NBSP * 2}#{@params[:inspection].community_mausoleum_comments}"],
        ['12. Private mausoleum', "#{smallcaps('yes')}", smallcaps('no'), "<font size='8'>#{smallcaps('Condition')}</font><br />#{Prawn::Text::NBSP * 2}#{@params[:inspection].private_mausoleum_comments}"],
        ['13. Lawn crypts', "#{smallcaps('yes')}", smallcaps('no'), "<font size='8'>#{smallcaps('Method of Approval')}</font><br />#{Prawn::Text::NBSP * 2}#{@params[:inspection].lawn_crypts_comments}"],
        ['14. Grave liners', "#{smallcaps('yes')}", smallcaps('no'), "<font size='8'>#{smallcaps('Number Stored')}</font><br />#{Prawn::Text::NBSP * 2}#{@params[:inspection].grave_liners_comments}"],
        ['15. Evidence of display or sale of monuments', "#{smallcaps('yes')}", smallcaps('no'), @params[:inspection].sale_of_monuments_comments],
        ['16. Fencing', "#{smallcaps('yes')}", smallcaps('no'), "<font size='8'>#{smallcaps('Describe')}</font><br />#{Prawn::Text::NBSP * 2}#{@params[:inspection].fencing_comments}"],
        ['17. Winter burials reasonable', "#{smallcaps('yes')}", smallcaps('no'), @params[:inspection].winter_burials_comments],
      ],
      cell_style: { border_lines: [:solid, :solid, :solid, :dotted], inline_format: true },
      column_widths: [bounds.width * 0.43, bounds.width * 0.06, bounds.width * 0.06, bounds.width * 0.45]
    ) do
      cells.borders = [:top]
      cells.height = 24
      column(0).size = 8
      columns([1, 2]).padding = [5, 5, 5, 0]
      columns([1, 2]).align = :right
      column(3).borders = [:top, :left]

      # Header row
      row(0).height = 20
      row(0).column(3).size = 8
      row(0).column(3).font_style = :bold

      rows([6, 7, 8, 9, 11]).column(3).padding = [0, 0, 0, 5]
    end
    stroke_horizontal_rule
    move_down 10
    stroke_horizontal_rule

    # Checkboxes
    values = %i(
      sign offices rules_displayed prices_displayed
      scattering_gardens community_mausoleum private_mausoleum
      lawn_crypts grave_liners sale_of_monuments fencing winter_burials)
    [494.5, 470.5, 446.5, 422.5, 398.5, 374.5, 350.5, 326.5, 302.5, 278.5, 254.5, 230.5].each_with_index do |y, i|
      checkbox(245, y, @params[:inspection].send(values[i]))
      checkbox(282, y, !@params[:inspection].send(values[i]))
    end

    move_down 20
    table(
        [
            [smallcaps('18. Main Road')],
            [@params[:inspection].main_road],
            [smallcaps('19. Side Roads')],
            [@params[:inspection].side_roads],
            [smallcaps('20. Condition of New Memorials')],
            [@params[:inspection].new_memorials],
            [smallcaps('21. Condition of Old Memorials')],
            [@params[:inspection].old_memorials],
            [smallcaps('22. Evidence of Vandalism')],
            [@params[:inspection].vandalism],
            [smallcaps('23. Evidence of Hazardous Materials')],
            [@params[:inspection].hazardous_materials]
        ],
        cell_style: { inline_format: true },
        width: bounds.width) do
      rows([0, 2, 4, 6, 8, 10]).padding = [0, 0, 0, 0]
      rows([0, 2, 4, 6, 8, 10]).borders = [:top]
      rows([0, 2, 4, 6, 8, 10]).size = 8

      rows([1, 3, 5, 7, 9, 11]).borders = []
    end
    stroke_horizontal_rule

    bounding_box([bounds.left, bounds.bottom + 5], width: 40, height: 20) do
      text smallcaps('DOS-540'), size: 8
    end

    bounding_box([bounds.left, bounds.bottom + 5], width: bounds.width, height: 20) do
      text '–– CONTINUED ON REVERSE ––', align: :center, size: 8, style: :bold
    end

    start_new_page

    # Create receiving vault table
    receiving_vaults = make_table(
      [
        ['YES', "#{Prawn::Text::NBSP * 5}Interior inspected", 'Number of bodies stored:'],
        ['NO', "#{Prawn::Text::NBSP * 5}Clean, dry, free of vermin and rodents", "#{Prawn::Text::NBSP * 5}Used exclusively for human remains"],
        ['', "#{Prawn::Text::NBSP * 5}Obscured from public view", "#{Prawn::Text::NBSP * 5}Secured when unattended"]
      ],
      cell_style: { borders: [] },
      column_widths: [bounds.width * 0.2, bounds.width * 0.4, bounds.width * 0.4]
    )

    # Receiving vault
    move_down 20
    table(
      [
        [smallcaps('24. Receiving Vaults')],
        [receiving_vaults],
        [smallcaps('25. Overall Conditions (sinkage and overgrowth)')],
        [@params[:inspection].overall_conditions],
        [smallcaps('26. Signs of Major Renovations')],
        [@params[:inspection].renovations]
      ],
      cell_style: { inline_format: true },
      width: bounds.width
    ) do
      rows([0, 2, 4]).padding = [0, 0, 0, 0]
      rows([0, 2, 4]).borders = [:top]
      rows([0, 2, 4]).size = 8

      rows([1, 3, 5]).borders = []
      row(1).column(0).padding = [0, 0, 10, 20]

      row(1).column(1).padding = [0, 40, 0, 0]

      row(3).height = 80
    end

    checkbox(15, 715.5, @params[:inspection].receiving_vault_exists)
    checkbox(15, 694.5, !@params[:inspection].receiving_vault_exists)
    checkbox(140, 715.5, @params[:inspection].receiving_vault_inspected)
    checkbox(140, 694.5, @params[:inspection].receiving_vault_clean)
    checkbox(362, 694.5, @params[:inspection].receiving_vault_exclusive)
    checkbox(140, 673.5, @params[:inspection].receiving_vault_obscured)
    checkbox(362, 673.5, @params[:inspection].receiving_vault_secured)

    stroke_horizontal_line 475, 515, at: 706
    bounding_box([475, 718], width: 40, height: 10) do
      text @params[:inspection].receiving_vault_bodies || '---', align: :center
    end

    move_down 200
    stroke_horizontal_rule
    move_down 10
    stroke_horizontal_rule

    # Record-keeping
    table(
      [
        [{ content: '', colspan: 3 }, 'REMARKS'],
        ['27. Annual meetings held and advertised', "#{smallcaps('yes')}", smallcaps('no'), "<font size='8'>#{smallcaps('Newspaper')}</font><br />#{Prawn::Text::NBSP * 2}#{@params[:inspection].annual_meetings_comments}"],
        ['28. Election held', "#{smallcaps('yes')}", smallcaps('no'), "<font size='8'>#{smallcaps('Number of Trustees')}</font><br />#{Prawn::Text::NBSP * 2}#{@params[:inspection].number_of_trustees}"],
        ['29. Burial permits filed within 7 days', smallcaps('yes'), smallcaps('no'), @params[:inspection].burial_permits_comments],
        ['30. Body delivery receipt issued', "#{smallcaps('yes')}", smallcaps('no'), @params[:inspection].body_delivery_receipt_comments],
        ['31. Deeds signed by president and treasurer', "#{smallcaps('yes')}", smallcaps('no'), @params[:inspection].deeds_signed_comments],
        ['32. Burial book and map kept up-to-date', "#{smallcaps('yes')}", smallcaps('no'), "<font size='8'>#{smallcaps('Location')}</font><br />#{Prawn::Text::NBSP * 2}#{@params[:inspection].burial_records_comments}"],
        ['33. Rules and regulations provided with deed', "#{smallcaps('yes')}", smallcaps('no'), @params[:inspection].rules_provided_comments],
        ['34. Rules and regulations approved by Division', "#{smallcaps('yes')}", smallcaps('no'), "<font size='8'>#{smallcaps('Last Updated')}</font><br />#{Prawn::Text::NBSP * 2}#{@params[:inspection].rules_approved_comments}"],
        ['35. Maintenance performed by employee', "#{smallcaps('yes')}", smallcaps('no'), @params[:inspection].employees_comments],
        ['36. Trustees compensated', "#{smallcaps('yes')}", smallcaps('no'), "<font size='8'>#{smallcaps('Positions and Amount')}</font><br />#{Prawn::Text::NBSP * 2}#{@params[:inspection].trustees_compensated_comments}"]
      ],
      cell_style: { border_lines: [:solid, :solid, :solid, :dotted], inline_format: true },
      column_widths: [bounds.width * 0.43, bounds.width * 0.06, bounds.width * 0.06, bounds.width * 0.45]
    ) do
      cells.borders = [:top]
      cells.height = 25
      column(0).size = 8
      columns([1, 2]).padding = [5, 5, 5, 0]
      columns([1, 2]).align = :right
      column(3).borders = [:top, :left]

      # Header row
      row(0).height = 20
      row(0).column(3).size = 8
      row(0).column(3).font_style = :bold

      rows([1, 2, 6, 8, 10]).column(3).padding = [0, 0, 0, 5]
    end
    stroke_horizontal_rule
    move_down 10
    stroke_horizontal_rule

    values = %i(
      annual_meetings election burial_permits
      body_delivery_receipt deeds_signed burial_records
      rules_provided rules_approved employees trustees_compensated
    )
    [468.5, 443.5, 418.5, 393.5, 368.5, 343.5, 318.5, 293.5, 268.5, 243.5].each_with_index do |y, i|
      checkbox(245, y, @params[:inspection].send(values[i]))
      checkbox(282, y, !@params[:inspection].send(values[i]))
    end

    # Summary and date
    move_down 20.5
    table(
        [
            [smallcaps('37. Items for Consideration of the Cemetery')],
            [items_for_consideration.join(' ')],
            [smallcaps('38. Date Letter Sent')],
            [@params[:inspection].date_mailed || 'Not yet sent']
        ],
        cell_style: { inline_format: true },
        width: bounds.width
    ) do
      rows([0, 2]).padding = [0, 0, 0, 0]
      rows([0, 2]).borders = [:top]
      rows([0, 2]).size = 8

      rows([1, 3]).borders = []
      row(1).column(0).padding = [5, 0, 10, 20]

      row(1).column(1).padding = [0, 40, 0, 0]

      row(1).height = 100
    end
    stroke_horizontal_rule
    move_down 75

    # Signature and date lines
    stroke_horizontal_line(0, 275, at: y)
    stroke_horizontal_line(bounds.width - 225, bounds.width, at: y)

    # Signature
    if @params[:signature]
      bounding_box [bounds.left, y + 39], width: 300 do
        image Rails.root.join('app', 'pdfs', 'signatures', @params[:signature]), height: 38, width: 140
      end
    end

    bounding_box([bounds.left, 20], width: 60, height: 40) do
      text smallcaps('Investigator'), size: 8
    end

    # Date
    bounding_box [bounds.width - 225, y + 38], width: 100 do
      text "#{@params[:inspection].date_performed}"
    end

    bounding_box([bounds.width - 225, 20], width: 40, height: 40) do
      text smallcaps('Date'), size: 8
    end
  end

  def document
    font_directory = Rails.root.join('app', 'pdfs', 'fonts')
    @document ||= Prawn::Document.new(margin: [20, 28])
    @document.font_families.update("Arial" => {
        normal: font_directory.join('Arial.ttf'),
        italic: font_directory.join('Arial Italic.ttf'),
        bold: font_directory.join('Arial Bold.ttf'),
        bold_italic: font_directory.join('Arial Bold Italic.ttf')
    })
    @document
  end

  private

  def checkbox(x, y, selected = false)
    bounding_box([x, y], width: 5, height: 5) do
      stroke_bounds
      text 'x', align: :center, size: 5, style: :bold if selected
    end
  end

  def items_for_consideration
    items_text = []
    items = YAML.load_file(Rails.root.join('config', 'cemetery_inspections.yml'))['cemetery_inspections']
    items.each do |item, values|
      items_text << values['report_text'] if !@params[:inspection].send(item).nil? && !@params[:inspection].send(item)
    end

    items_text
  end

  def smallcaps(string)
    string = string.tr('a-z', 'ᴀʙᴄᴅᴇғɢʜɪᴊᴋʟᴍɴᴏᴘǫʀsᴛᴜᴠᴡxʏᴢ')
    string.gsub(/ғ/, '<font size="5.9125">F</font>')
  end
end