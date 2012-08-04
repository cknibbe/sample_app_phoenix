require 'spec_helper'

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_banner(heading, full_title(page_title))}
  end 

  describe "Home page" do
    before { visit root_path }

    let(:heading)     { 'Sample App' }
    let(:page_title)  { '' }
    it_should_behave_like "all static pages"

    it { should_not have_selector('title', text: '| Home') }
    
    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }
      
      it "should render the user's feed" do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        visit root_path
        
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end
      
      describe "should include count" do
        it "of '0' microposts" do
          visit root_path
          page.should have_content("0 microposts")
        end
        
        it "of '1' micropost" do
          FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
          visit root_path
          page.should have_content("1 micropost")
        end
        
        it "of 'n' microposts" do
          FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
          FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
          visit root_path
          page.should have_content("#{user.microposts.count} microposts")
        end
      end
    end
  end

  describe "Help page" do
    before { visit help_path }

    let(:heading)     { 'Help' }
    let(:page_title)  { 'Help' }
    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }

    let(:heading)     { 'About Us' }
    let(:page_title)  { 'About' }
    it_should_behave_like "all static pages"
  end

 describe "Contact page" do
    before { visit contact_path }

    let(:heading)     { 'Contact' }
    let(:page_title)  { 'Contact' }
    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', text: full_title('About Us')
    click_link "Help"
    page.should have_selector 'title', text: full_title('Help')
    click_link "Contact"
    page.should have_selector 'title', text: full_title('Contact')
    click_link "Home"
    click_link "Sign up now!"
    page.should have_selector 'title', text: full_title('Sign up')
  end
end
