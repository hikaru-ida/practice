require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature "Questions", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:question) { FactoryBot.create(:question, :with_two_answers) }
  scenario "login user add a question", js: true do
    login_as(user, scope: :user)
    visit new_question_path
    fill_in :question_content, with: '質問1'
    fill_in :question_description, with: '説明1'

    (all("#answer-field")[0]).set("回答1")
    (all("#answer-field")[1]).set("回答2")

    click_button '質問作成'
    expect(page).to have_content '質問を作成しました'
    sleep(4)
    expect(page).to_not have_content '質問を作成しました'
  end

  scenario "user can't add a question without valid input", js: true do
    login_as(user, scope: :user)
    visit new_question_path
    expect(page).to have_button('質問作成', disabled: true)
    fill_in :question_content, with: '質問1'
    fill_in :question_description, with: '説明1'

    (all("#answer-field")[0]).set("回答1")
    (all("#answer-field")[1]).set("回答2")
    expect(page).to have_button('質問作成', disabled: false)
    (all("#answer-field")[1]).set("")
    expect(page).to have_button('質問作成', disabled: true)

    click_link '回答を追加する'
    (all("#answer-field")[2]).set("回答3")
    expect(page).to have_button('質問作成', disabled: false)
  end
end
