require "test_helper"

describe Product do
  describe "relationships" do
    before do
      @merchant = Merchant.create!(username: "Captain", email: "captain@email.com", uid: 99999)
      @product = Product.new(name: "fries", price: 10.00)
    end

    it "product belongs to merchant" do
      @product.merchant = @merchant

      @product.save
      @product = Product.find_by(id: @product.id)

      expect(@product.merchant).must_equal @merchant
    end

    # TODO: has many reviews
    # it "product has many reviews" do
    #   @reviews = [Review.new(rating: 5), Review.new(rating: 4)]
    #   @product.reviews = @reviews
    #
    #   @product.save
    #   @product = Product.find_by(id: @product.id)
    #
    #   expect(@product.reviews.size).must_equal @reviews.size
    # end

    it "product has many categorizations" do
      @categorizations = [Categorization.new(name: 'Clothes'), Categorization.new(name: 'Kitchen')]
      @product.categorizations = @categorizations

      @product.save
      @product = Product.find_by(id: @product.id)

      expect(@product.categorizations.size).must_equal @categorizations.size
    end

    # TODO: belongs to many categorizations

    # TODO: has many order items

    # TODO: has many orders
  end

  describe 'validations' do
    before do
      @merchant = Merchant.create(email: "email@123.com", username: "kayla-bo-bayla", uid: 99999)
      @product = Product.create(name: "Shoyru", price: 5.00, merchant_id: @merchant[:id], quantity: 500)
    end

    it "is valid when all fields are filled" do

      #Act/Assert
      result = @product.valid?
      expect(result).must_equal true
    end

    it "is invalid without a merchant" do

      #Act/Assert
      @product.merchant_id = nil
      expect(@product.valid?).must_equal false
      expect(@product.errors.messages.include?(:merchant)).must_equal true
      expect(@product.errors.messages[:merchant].include?("must exist")).must_equal true

    end

    it "fails validation when there is no product name" do

      #Act/Assert
      @product.name = nil
      expect(@product.valid?).must_equal false
      expect(@product.errors.messages.include?(:name)).must_equal true
      expect(@product.errors.messages[:name].include?("can't be blank")).must_equal true
    end

    it "fails validation when there is no product price" do

      #Act/Assert
      @product.price = nil
      expect(@product.valid?).must_equal false
      expect(@product.errors.messages.include?(:price)).must_equal true
      expect(@product.errors.messages[:price].include?("is not a number")).must_equal true

    end

    it "fails validation when the price is set to 0" do

      #Act/Assert
      @product.price = 0.0
      expect(@product.valid?).must_equal false
      expect(@product.errors.messages.include?(:price)).must_equal true
      expect(@product.errors.messages[:price].include?("must be greater than 0")).must_equal true


    end
    it "fails validation when the product name already exists" do

      #Act
      new_product = Product.create(name: @product.name, price: 10.00, merchant_id: @merchant[:id])

      #Assert
      expect(new_product.valid?).must_equal false
      expect(new_product.errors.messages.include?(:name)).must_equal true
      expect(new_product.errors.messages[:name].include?("has already been taken")).must_equal true
    end
  end
end
