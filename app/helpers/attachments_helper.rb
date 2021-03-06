module AttachmentsHelper
  def attachment_display_link(attachment, request)
    if %w(application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document).include? attachment.content_type
      "https://view.officeapps.live.com/op/embed.aspx?src=#{request.protocol}#{request.host}#{url_for attachment}"
    elsif attachment.content_type == 'application/pdf'
      pdfjs.full_path(file: url_for(attachment))
    end
  end

  def view_attachment_link(object, attachment)
    if %w(application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document application/pdf image/jpeg).include? attachment.file.content_type
      polymorphic_url([object, attachment])
    else
      rails_blob_path(attachment.file)
    end
  end
end