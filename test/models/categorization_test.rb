require "test_helper"

describe Categorization do
  before do
    @kitchen = categorizations(:kitchen)
    @apparel = categorizations(:apparel)
    @electronics = categorizations(:electronics)
    @computers = categorizations(:computers)
  end

  describe "instantiation" do
    it "can be instantiated" do
      expect(@kitchen.valid?).must_equal true
      expect(@apparel.valid?).must_equal true
      expect(@electronics.valid?).must_equal true
      expect(@computers.valid?).must_equal true
    end

    it "will have the required fields" do
      [@kitchen, @apparel, @electronics, @computers].each do |categorization|
        expect(categorization).must_respond_to :id
        expect(categorization).must_respond_to :name
        expect(categorization).must_respond_to :created_at
        expect(categorization).must_respond_to :updated_at
      end
    end
  end

  describe "validations" do
    it "categorization is valid if name is present" do
      new_category = Categorization.new(name: "taxidermy")

      expect(new_category.valid?).must_equal true
    end

    it "categorization is invalid if name is nil" do
      new_category = Categorization.new(name: nil)

      expect(new_category.valid?).must_equal false
      expect(new_category.errors.messages).must_include :name
      expect(new_category.errors.messages[:name]).must_equal ["can't be blank"]
    end

    it "categorization must have a unique name" do
      new_category = Categorization.new(name: "kitchen")

      expect(new_category.valid?).must_equal false
      expect(new_category.errors.messages).must_include :name
      expect(new_category.errors.messages[:name]).must_equal ["has already been taken"]
    end
  end

  describe "relationships" do
    it "categorization can belong to many products" do
      laptop = products(:laptop)
      desktop = products(:desktop)

      laptop.categorizations << @computers
      desktop.categorizations << @computers

      assert_operator @computers.products.count, :>, 1

      @computers.products.each do |product|
        expect(product).must_be_instance_of Product
      end
    end

    it "products can have many categorizations" do
      laptop = products(:laptop)

      laptop.categorizations << @computers
      laptop.categorizations << @electronics

      assert_operator laptop.categorizations.count, :>, 1

      laptop.categorizations.each do |categorizations|
        expect(categorizations).must_be_instance_of Categorization
      end
    end
  end
end
