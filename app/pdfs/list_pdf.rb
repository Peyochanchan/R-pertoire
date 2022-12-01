class ListPdf < Prawn::Document
  include ApplicationHelper

  def initialize(list, lsongs)
    super()
    @list = list
    @lsongs = lsongs
    content
  end

  def content
    self.line_width = 3
    stroke do
      bounding_box([15, cursor - 5], width: 510) do
        move_down 10
        text_content(0)
      end
    end
  end

  def text_content(order)
    round_rectangle
    image StringIO.open(@list.photo.download), height: 100, at: [10, cursor - 10] if @list.photo.present?
    bounding_box([190, cursor], width: 300, height: 100) do
      font_size(30) do
        pad(40) { text @list.name.to_s, align: :center, overflow: :shrink_to_fit }
      end
    end
    svg StringIO.open(@list.qr_code.html_safe), position: :center, width: 40

    move_down 5
    stroke do
      pad(20) { horizontal_rule }
    end
    move_down 5
    @lsongs.each do |lsong|
      order += 1
      font('Courier', size: 18) do
        text "#{order} - #{lsong.tonality.present? ? "#{lsong.tonality} - " : "" }<b>#{lsong.song.title}</b> - #{lsong.song.composer}",
        inline_format: true,
        align: :left,
        leading: 16
      end
    end

    start_new_page
    span(350, position: :center) do
      move_down 20
      font('Courier', size: 32) do
        text "<b>#{@list[translater('name')[I18n.locale]]}</b>", inline_format: true, align: :center
      end
      move_down 20
    end
    span(400, position: :center) do
      text "#{@list[translater('description')[I18n.locale]]}", align: :justify
    end
    move_down 70
    svg StringIO.open(@list.qr_code.html_safe), position: :center, width: 300
  end

  def round_rectangle
    repeat(:all) do
      self.line_width = 3
      stroke do
        rounded_rectangle [-15, cursor + 25], 540, 740, 20
      end
    end
    repeat(:all, dynamic: true) do
      string = 'page <page> / <total>'
      options = {
        at: [bounds.right - 160, 720],
        width: 150,
        align: :right,
        page_filter: ->(pg) { pg != page_count },
        total_pages: page_count - 1,
        start_count_at: 1,
        color: '333333'
      }
      number_pages(string, options)
    end
  end
end
