# spec/support/pdf_helpers.rb
require "pdf/reader"
require "stringio"

module PdfHelpers
  # Parses raw PDF bytes and returns [pages_text, page_count]
  def pdf_text_and_pages(pdf_binary)
    io   = StringIO.new(pdf_binary)
    text = []
    PDF::Reader.new(io).pages.each { |p| text << p.text }
    [text.join("\n"), text.size]
  end

  # Quick guardrails to assert it *is* a PDF
  def expect_pdf_response!(response)
    # Rack::Test exposes headers + body
    expect(response).to have_http_status(:ok)
    expect(response.media_type).to eq("application/pdf")
    expect(response.body).to start_with("%PDF")
  end
end

RSpec.configure { |c| c.include PdfHelpers }
