class Item
  def initialize(name : String, price : String, datetime : Time)
    @name = name
    @price = price
    @datetime = datetime
  end

  def name
    @name
  end

  def price
    @price
  end

  def datetime
    @datetime
  end
end
