require 'rails_helper'

RSpec.describe "applies/show", type: :view do
  before(:each) do
    @apply = assign(:apply, Apply.create!(
      :create => "Create",
      :destroy => "Destroy"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Create/)
    expect(rendered).to match(/Destroy/)
  end
end
