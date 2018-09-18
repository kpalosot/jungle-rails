require 'rails_helper'

RSpec.feature "Visitor navigates to a product page", type: :feature, js: true do
  before :each do
    @category = Category.create! name: 'Apparel'

    10.times do |n|
      @category.products.create!(
        name:  Faker::Hipster.sentence(3),
        description: Faker::Hipster.paragraph(4),
        image: open_asset('apparel1.jpg'),
        quantity: 10,
        price: 64.99
      )
    end
  end

  scenario "They see the product description" do
    visit root_path

    expect(page).to have_css('.products-index')

    first(:link, 'Details').click

    expect(page).to have_css ('.product-detail')

    save_screenshot

  end

end
