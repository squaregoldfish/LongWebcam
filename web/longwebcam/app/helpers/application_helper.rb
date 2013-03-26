module ApplicationHelper

    def full_title(page_title)

        title = "Long Webcam"
        if !page_title.empty?
            title = "#{page_title} - #{title}"
        end

        title
    end
end
