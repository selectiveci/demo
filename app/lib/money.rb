module Money
  module_function

  def format(cents)
    sign = cents.negative? ? "-" : ""
    dollars, remainder = cents.abs.divmod(100)
    "#{sign}$#{dollars.to_s.reverse.scan(/\d{1,3}/).join(",").reverse}.#{remainder.to_s.rjust(2, "0")}"
  end

  def percent_of(cents, rate)
    (cents * rate).round(half: :even)
  end
end
