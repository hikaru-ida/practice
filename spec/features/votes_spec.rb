require 'rails_helper'

RSpec.feature "Votes", type: :feature do
  let(:user) { FactoryBot.create(:user)}
  let(:question) { FactoryBot.create(:question, :with_two_answers) }
  scenario "authorized user can vote successfully", js: true do
    login_as(user)
    visit question_path(question.id)
    all('.vote-button .btn')[0].click
    expect(page).to have_content /回答[0-9]*に投票しました/
    sleep(5)
    expect(page).to_not have_content /回答[0-9]*に投票しました/

    expect(page).to have_css('div.chart')
  end
end
