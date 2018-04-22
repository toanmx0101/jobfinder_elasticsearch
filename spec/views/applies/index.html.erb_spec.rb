require 'rails_helper'

RSpec.describe "applies/index", type: :view do
  before(:each) do
    assign(:applies, [
      Apply.create!(
        :create => "Create",
        :destroy => "Destroy"
      ),
      Apply.create!(
        :create => "Create",
        :destroy => "Destroy"
      )
    ])
  end

  it "renders a list of applies" do
    render
    assert_select "tr>td", :text => "Create".to_s, :count => 2
    assert_select "tr>td", :text => "Destroy".to_s, :count => 2
  end
end
