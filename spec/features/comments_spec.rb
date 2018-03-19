require 'rails_helper'

RSpec.feature "Comments", type: :feature do
  let(:user) { FactoryBot.create(:user)}
  let(:question) { FactoryBot.create(:question, :with_two_answers)}

  context "from queston page" do
    scenario "user can make a comment on the voted question", js: true do
      login_as(user)
      visit question_path(question.id)
      all('.vote-button .btn')[0].click
      fill_in :comment_content, with: "コメント1"
      click_on(class: 'btn-post')
      expect(page).to have_content "コメントしました"
    end
  end

  context "from comments page" do
    scenario "user can make a comment on the voted question", js: true do
      login_as(user)
      visit question_path(question.id)
      expect(page).to_not have_css('div.comment-field-bottom')
      all('.vote-button .btn')[0].click
      fill_in :comment_content, with: "コメント2"
      click_on(class: 'btn-post')
      expect(page).to have_content "コメントしました"
    end
  end
end
