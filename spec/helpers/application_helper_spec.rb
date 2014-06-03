require 'spec_helper'

describe ApplicationHelper do
  describe '#markdown' do
    it 'should output rendered markdown' do
      markdown = 'This **is** (bold)\n'
      html = "<p>This <strong>is</strong> (bold)\\n</p>\n"

      expect(helper.markdown(markdown)).to eq(html)
    end

    it 'should filter html tags from markdown' do
      markdown = 'Text with filtered <b>HTML</b> tags <script>alert("!");</script>\n'
      html = "<p>Text with filtered HTML tags alert(&quot;!&quot;);\\n</p>\n"

      expect(helper.markdown(markdown)).to eq(html)
    end

    it 'should auto wrap hyperlinks' do
      markdown = 'http://it61.info'
      html = "<p><a href=\"http://it61.info\">http://it61.info</a></p>\n"

      expect(helper.markdown(markdown)).to eq(html)
    end

  end
end