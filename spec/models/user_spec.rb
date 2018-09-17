require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Validations:" do

    context "Testing by checking presence of attribtes (shoulda-matchers" do
      it { is_expected.to validate_presence_of(:first_name) }
      it { is_expected.to validate_presence_of(:last_name) }
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_presence_of(:password) }
      it { is_expected.to validate_confirmation_of(:password) }
      it { is_expected.to validate_presence_of(:password_confirmation) }
    end

    context "Testing using invalid values" do
      before do
        @ender = User.new(
          first_name: 'Ender',
          last_name: 'Wiggin',
          email: 'enderwiggin@gmail.com',
          password: '123',
          password_confirmation: '123'
        )
        @mazer = User.create(
          first_name: 'Mazer',
          last_name: 'Rackham',
          email: 'mazerrackham@gmail.com',
          password: '123',
          password_confirmation: '123'
        )
      end

      it "should be invalid if there are no first name provided" do
        @ender.first_name = nil
        expect(@ender).to_not be_valid
        expect(@ender.errors.full_messages).to_not be_empty
      end

      it "should be invalid if there are no last name provided" do
        @ender.last_name = nil
        expect(@ender).to_not be_valid
        expect(@ender.errors.full_messages).to_not be_empty
      end

      context "Testing on emails" do
        it "should be invalid if there are no email provided" do
          @ender.email = nil
          expect(@ender).to_not be_valid
          expect(@ender.errors.full_messages).to_not be_empty
        end

        it "should be invalid if exact email already exists in the database" do
          @mazer2 = User.new(
            first_name: 'Mazer',
            last_name: 'Rackham',
            email: 'mazerrackham@gmail.com',
            password: '123',
            password_confirmation: '123'
          )
          expect(@mazer2).to_not be_valid
          expect(@mazer2.errors.full_messages).to_not be_empty
        end

        it "should be invalid if email(not case sensitive) already exists in the database" do
          @mazer2 = User.new(
            first_name: 'Mazer',
            last_name: 'Rackham',
            email: 'MAZERRACKHAM@GMAIL.com',
            password: '123',
            password_confirmation: '123'
          )
          expect(@mazer2).to_not be_valid
          expect(@mazer2.errors.full_messages).to_not be_empty
        end
      end

      context "Testing on password" do
        it "should be invalid if there are no password provided" do
          @ender.password = nil
          expect(@ender).to_not be_valid
          expect(@ender.errors.full_messages).to_not be_empty
        end

        it "should be invalid if there are no password confirmation provided" do
          @ender.password_confirmation = nil
          expect(@ender).to_not be_valid
          expect(@ender.errors.full_messages).to_not be_empty
        end

        it "should be invalid if there are password and password confirmation provided" do
          @ender.password_confirmation = '456'
          expect(@ender).to_not be_valid
          expect(@ender.errors.full_messages).to_not be_empty
        end

        it "should be invalid if password is less than 3 characters" do
          @ender.password = '12'
          @ender.password_confirmation = '12'
          expect(@ender).to_not be_valid
          expect(@ender.errors.full_messages).to_not be_empty
        end
      end

    end

  end

  describe ".authenticate_with_credentials:" do
    before do
      @ender = User.create(
        first_name: 'Ender',
        last_name: 'Wiggin',
        email: 'enderwiggin@gmail.com',
        password: '123',
        password_confirmation: '123'
      )
    end

    context "Password authentication" do
      it "should return the user if the user gives the correct password" do
        @correct_user = User.authenticate_with_credentials('enderwiggin@gmail.com', '123')
        expect(@correct_user).to eql(@ender)
      end

      it "should return nil if the user gives an incorrect password" do
        @incorrect_user = User.authenticate_with_credentials('enderwiggin@gmail.com', '456')
        expect(@incorrect_user).to eql(nil)
      end
    end

    context "Email trailing whitespaces" do
      it "should return the correct user even if email has trailing whitespaces" do
        # left trailing space
        @correct_user1 = User.authenticate_with_credentials('     enderwiggin@gmail.com', '123')
        expect(@correct_user1).to eql(@ender)

        # right trailing space
        @correct_user2 = User.authenticate_with_credentials('enderwiggin@gmail.com     ', '123')
        expect(@correct_user2).to eql(@ender)

        # new line trailing space
        @correct_user3 = User.authenticate_with_credentials("enderwiggin@gmail.com\n", '123')
        expect(@correct_user3).to eql(@ender)

        # all
        @correct_user4 = User.authenticate_with_credentials("    enderwiggin@gmail.com    \n", '123')
        expect(@correct_user4).to eql(@ender)
      end
    end

    context "Email with wrong case letters" do
      it "should return the correct user even if email is typed with wrong case letters" do
        # User wrong case
        @user1 = User.authenticate_with_credentials('EnderWiggin@gmail.com', '123')
        expect(@user1).to eql(@ender)

        # User wrong case 2
        @user2 = User.authenticate_with_credentials('ENDERWIGGIN@gmail.com', '123')
        expect(@user2).to eql(@ender)

        # Domain case mistake
        @user3 = User.authenticate_with_credentials('enderwiggin@GMAIL.COM', '123')
        expect(@user3).to eql(@ender)
      end
    end

  end

end
