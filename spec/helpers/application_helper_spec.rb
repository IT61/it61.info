require 'spec_helper'

describe ApplicationHelper do
  describe '#markdown' do
    it 'should output rendered markdown' do
      markdown = 'This **is** (bold)\n'
      html = "<p>This <strong>is</strong> (bold)\\n</p>\n"

      expect(helper.markdown(markdown)).to eq(html)
    end

    it 'should escape html tags from markdown' do
      markdown = 'Text with escaped <b>HTML</b> tags <script>alert("!");</script>'
      html = "<p>Text with escaped &lt;b&gt;HTML&lt;/b&gt; tags &lt;script&gt;alert(&quot;!&quot;);&lt;/script&gt;</p>\n"

      expect(helper.markdown(markdown)).to eq(html)
    end

    it 'should auto wrap hyperlinks' do
      markdown = 'http://it61.info'
      html = "<p><a href=\"http://it61.info\">http://it61.info</a></p>\n"

      expect(helper.markdown(markdown)).to eq(html)
    end

  end
end