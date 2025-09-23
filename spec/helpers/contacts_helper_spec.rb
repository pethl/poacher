# frozen_string_literal: true
require "rails_helper"

RSpec.describe ContactsHelper, type: :helper do
  # convenience: stub `params` for helpers that read it
  def set_params(hash)
    allow(helper).to receive(:params)
      .and_return(ActionController::Parameters.new(hash))
  end

  describe "#next_direction" do
    it "returns desc when current is asc" do
      set_params(direction: "asc")
      expect(helper.next_direction).to eq("desc")
    end

    it "returns asc when current is desc or nil" do
      set_params(direction: "desc")
      expect(helper.next_direction).to eq("asc")

      set_params({})
      expect(helper.next_direction).to eq("asc")
    end
  end

  describe "#contacts_sort_link" do
    it "builds an asc link when sorting a new column" do
      set_params(column: "name", direction: "desc") # currently sorting :name
      html = helper.contacts_sort_link(column: "email", label: "Email")
      doc  = Nokogiri::HTML.fragment(html)
      a    = doc.at_css("a")

      expect(a.text).to eq("Email")
      expect(a["href"]).to include(contacts_path(column: "email", direction: "asc"))
      expect(a["data-turbo-action"]).to eq("replace")
    end

    it "toggles to desc when clicking same column" do
      set_params(column: "name", direction: "asc")
      html = helper.contacts_sort_link(column: "name", label: "Name")
      a    = Nokogiri::HTML.fragment(html).at_css("a")

      expect(a["href"]).to include(contacts_path(column: "name", direction: "desc"))
    end
  end

  describe "#contacts_sort_indicator" do
    it "renders a span with the current direction class" do
      set_params(direction: "asc")
      html = helper.contacts_sort_indicator
      span = Nokogiri::HTML.fragment(html).at_css("span.sort.sort-asc")
      expect(span).to be_present
    end
  end

  describe "#contacts_show_sort_indicator_for" do
    it "shows indicator when the column matches" do
      set_params(column: "name", direction: "asc")
      html = helper.contacts_show_sort_indicator_for("name")
      expect(html).to include('class="sort sort-asc"')
    end

    it "returns nil when the column does not match" do
      set_params(column: "name", direction: "asc")
      expect(helper.contacts_show_sort_indicator_for("email")).to be_nil
    end
  end

  describe "#filter_arrow" do
    it "returns down arrow when current column asc" do
      set_params(column: "name", direction: "asc")
      out = helper.filter_arrow("name")
      expect(out.to_s).to eq("&#8659;")
      expect(out).to be_html_safe
    end

    it "returns up arrow when current column desc" do
      set_params(column: "name", direction: "desc")
      out = helper.filter_arrow("name")
      expect(out.to_s).to eq("&#8657;")
      expect(out).to be_html_safe
    end

    it "returns nil when asking for a different column" do
      set_params(column: "name", direction: "asc")
      expect(helper.filter_arrow("email")).to be_nil
    end
  end
end
