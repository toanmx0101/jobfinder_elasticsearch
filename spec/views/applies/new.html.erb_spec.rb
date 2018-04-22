require 'rails_helper'

RSpec.describe "applies/new", type: :view do
  before(:each) do
    assign(:apply, Apply.new(
      :create => "MyString",
      :destroy => "MyString"
    ))
  end

  it "renders new apply form" do
    render

    assert_select "form[action=?][method=?]", applies_path, "post" do

      assert_select "input[name=?]", "apply[create]"

      assert_select "input[name=?]", "apply[destroy]"
    end
  end
end
