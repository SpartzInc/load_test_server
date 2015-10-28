#Simple class to do some linear regression for me
#http://engineering.sharethrough.com/blog/2012/09/12/simple-linear-regression-using-ruby/
module Helpers
  class SimpleLinearRegression
    def initialize(xs, ys)
      @xs, @ys = xs, ys
      if @xs.length != @ys.length
        raise "Unbalanced data. xs need to be same length as ys"
      end
    end

    def slope
      x_mean = mean(@xs)
      y_mean = mean(@ys)

      numerator = (0...@xs.length).reduce(0) do |sum, i|
        sum + ((@xs[i] - x_mean) * (@ys[i] - y_mean))
      end

      denominator = @xs.reduce(0) do |sum, x|
        sum + ((x - x_mean) ** 2)
      end

      (numerator / denominator)
    end

    def mean(values)
      total = values.reduce(0) { |sum, x| x + sum }
      Float(total) / Float(values.length)
    end

    def y_intercept
      mean(@ys) - (slope * mean(@xs))
    end

    #y = (slope)x + y_intercept
    def y(x)
      slope * x + y_intercept
    end

    #y = (slope)x + y_intercept
    #(slope)x = y - y_intercept
    #x = (y - y_intercept) / slope
    def x(y)
      (y - y_intercept) / slope
    end
  end
end