require 'rails_helper'

RSpec.describe "applies/edit", type: :view do
  before(:each) do
    @apply = assign(:apply, Apply.create!(
      :create => "MyString",
      :destroy => "MyString"
    ))
  end

  it "renders the edit apply form" do
    render

    assert_select "form[action=?][method=?]", apply_path(@apply), "post" do

      assert_select "input[name=?]", "apply[create]"

      assert_select "input[name=?]", "apply[destroy]"
    end
  end
end
