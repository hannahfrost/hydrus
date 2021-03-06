require 'spec_helper'

describe("Item edit", :type => :request) do
  fixtures :users

  before :each do
    @druid = 'druid:oo000oo0001'
    @hi    = Hydrus::Item.find @druid
  end

  it "If not logged in, should be redirected to sign-in page" do
    logout
    visit edit_polymorphic_path(@hi)
    current_path.should == new_user_session_path
  end

  it "Can edit basic content" do
    new_name  = 'abcxyz123'
    orig_name = @hi.descMetadata.originInfo.publisher.first

    login_as_archivist1

    visit edit_polymorphic_path(@hi)
    current_path.should == edit_polymorphic_path(@hi)

    find_field("Publisher").value.should == orig_name
    fill_in "Publisher", :with => new_name
    click_button "Save"

    current_path.should == polymorphic_path(@hi)
    visit polymorphic_path(@hi)
    page.should have_content(new_name)

    # Clean up.
    visit edit_polymorphic_path(@hi)
    current_path.should == edit_polymorphic_path(@hi)
    fill_in "Publisher", :with => orig_name
    click_button "Save"
  end

  it "People/Role editing" do
    new_name  = "MY EDITIED PERSON"
    orig_name = "Rosenfeld, Michael J."
    field_np  = "asset_descMetadata_name_namePart_0"
    field_rt  = "asset_descMetadata_name_role_roleTerm_0"
    orig_role = "Principal Investigator"
    new_role  = "Collector"

    login_as_archivist1

    visit edit_polymorphic_path(@hi)
    current_path.should == edit_polymorphic_path(@hi)

    find_field(field_np).value.should == orig_name
    page.should have_content(orig_role)

    fill_in(field_np, :with => new_name)
    select(new_role, :from => field_rt)
    click_button "Save"

    current_path.should == polymorphic_path(@hi)
    visit polymorphic_path(@hi)
    page.should have_content(new_name)
    page.should have_content(new_role)

    # Clean up.
    visit edit_polymorphic_path(@hi)
    current_path.should == edit_polymorphic_path(@hi)
    fill_in(field_np, :with => orig_name)
    select(orig_role, :from => field_rt)
    click_button "Save"
  end

  it "Related Content editing" do
    orig_link   = "http://www.gutenberg.org/ebooks/500"
    new_link    = "foo_LINK_bar"
    field_link  = "asset_descMetadata_relatedItem_identifier_0"
    field_title = "asset_descMetadata_relatedItem_titleInfo_title_0"
    orig_title  = "Online survey research site (really Project Gutenberg)"
    new_title   = "foo_TITLE_bar"

    login_as_archivist1

    visit edit_polymorphic_path(@hi)
    current_path.should == edit_polymorphic_path(@hi)

    find_field(field_link).value.should == orig_link
    find_field(field_title).value.should == orig_title

    fill_in(field_link,  :with => new_link)
    fill_in(field_title, :with => new_title)
    click_button "Save"

    current_path.should == polymorphic_path(@hi)
    visit polymorphic_path(@hi)
    page.should have_xpath("//dd/a[@href='#{new_link}']")
    page.should have_content(new_title)

    # Clean up.
    visit edit_polymorphic_path(@hi)
    current_path.should == edit_polymorphic_path(@hi)
    fill_in(field_link,  :with => orig_link)
    fill_in(field_title, :with => orig_title)
    click_button "Save"
  end

end
