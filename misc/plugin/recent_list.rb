#
# recent_list: �Ƕ�񤤤������Υ����ȥ롤���֥����ȥ��ɽ������
#   �ѥ�᥿(���å����̤���������):
#     days:            ����ʬ��������ɽ�����뤫(20)
#     date_format:     ����ɽ���ե����ޥå�(���������եե����ޥå�)
#     title_with_body: true�ǳƥѥ饰��դؤΥ�󥯤�title°���ˤ��Υѥ饰��դΰ��������(false)
#     show_size:       true������Ģ��ɽ��(false)
#
#   ����: �����奢�⡼�ɤǤϻȤ��ޤ���
#   ����: �����ȥ�ꥹ�Ȥ�������������ϡ��쥤�����Ȥ��פ��ʤ����
#         �ʤ�ޤ��󡣥إå���եå���table������Ȥä��ꡢCSS��񤭴�
#         ����ɬ�פ�����Ǥ��礦��
#
# Copyright (c) 2000-2001 Junichiro KITA <kita@kitaj.no-ip.com>
# Distributed under the GPL
#
eval( <<MODIFY_CLASS, TOPLEVEL_BINDING )
class TDiaryMonth
  attr_reader :diaries
end

class Paragraph
  def shorten(len = 120)
    lines = NKF::nkf("-e -m0 -f#{len}", @body.gsub(/<.+?>/, '')).split("\n")
    lines[0].concat('...') if lines[0] and lines[1]
    lines[0]
  end
end
MODIFY_CLASS

def recent_list(days = 30, date_format = @date_format,
                title_with_body = false, show_size = false)
  result = ""
  cgi = CGI::new

  catch(:exit) {
    @years.keys.sort.reverse_each do |year|
      @years[year].sort.reverse_each do |month|
        cgi.params['date'] = ["#{year}#{month}"]
        m = TDiaryMonth::new(cgi, '')
        m.diaries.keys.sort.reverse_each do |date|
          result << %Q|<p class="recentitem"><a href="#{@index}?date=#{date}">#{m.diaries[date].date.strftime(date_format)}</a>\n|
          #result << %Q| #{m.diaries[date].title}| if m.diaries[date].title
          if show_size == true
            s = 0
            m.diaries[date].each_paragraph do |paragraph|
              s = s + paragraph.to_s.size.to_i
            end
            result << ":#{s}"
          end
          result << %Q|</p>\n<div class="recentsubtitles">\n|

          i = 1
          m.diaries[date].each_paragraph do |paragraph|
            if paragraph.subtitle
              result << %Q| <a href="#{@index}?date=#{date}#p#{'%02d' % i}"|
              result << %Q| title="#{CGI::escapeHTML(paragraph.shorten)}"| \
                if title_with_body == true
              result << %Q|>#{i}</a>. | \
                     << %Q|#{paragraph.subtitle}<br>\n|
            end
            i += 1
          end
          result << "</div>\n"
          days -= 1
          throw :exit if days == 0
        end
      end
    end
  }
  result
end

#@recent_list_cache = Cache.new(:recent_list, method(:recent_list), 10, '%Y/%m/%d', true, true)
#add_update_proc @recent_list_cache.writer
