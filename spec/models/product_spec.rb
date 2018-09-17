require 'rails_helper'

RSpec.describe Product, type: :model do
  describe "Validations" do

    context "Testing by checking presence of attributes (shoulda-matchers)" do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:price) }
      it { is_expected.to validate_presence_of(:quantity) }
      it { is_expected.to validate_presence_of(:category) }
    end

    context "Testing using invalid values" do
      before do
        @electronics = Category.create(name: 'Electronics')
        @headphones = Product.new(
          name: 'Headphones',
          price_cents: 6000,
          quantity: 5,
          category: @electronics
        )
      end

      it 'should save' do
        expect(@headphones.save).to eql(true)
      end

      it 'should return be invalid if it has no name' do
        @headphones.name = nil
        expect(@headphones).to_not be_valid
        expect(@headphones.errors.full_messages).to_not be_empty
      end

      it 'should return be invalid if it has no quantity' do
        @headphones.quantity = nil
        expect(@headphones).to_not be_valid
        expect(@headphones.errors.full_messages).to_not be_empty
      end

      it 'should return be invalid if it has no price' do
        @headphones.price_cents = nil
        expect(@headphones).to_not be_valid
        expect(@headphones.errors.full_messages).to_not be_empty
      end

      it 'should return be invalid if it has no category' do
        @headphones.category = nil
        expect(@headphones).to_not be_valid
        expect(@headphones.errors.full_messages).to_not be_empty
      end

    end

  end
end
