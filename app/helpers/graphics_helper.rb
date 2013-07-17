require 'matrix'

module GraphicsHelper
  def regression x, y, degree
    x_data = x.map {|xi| (0..degree).map{|pow| (xi**pow) }}
    mx = Matrix[*x_data]
    my = Matrix.column_vector y

    ((mx.t * mx).inv * mx.t * my).transpose.to_a[0].reverse
  end
end
