# frozen_string_literal: true

# A quaternion
class Quaternion
  attr_accessor :w, :x, :y, :z

  def initialize(w, x, y, z)
    @w = w
    @x = x
    @y = y
    @z = z
  end

  def +(other)
    return Quaternion.new(w + other, x, y, z) if other.is_a? Numeric

    Quaternion.new(
      w + other.w,
      x + other.x,
      y + other.y,
      z + other.z
    )
  end

  def *(other)
    if other.is_a? Numeric
      return Quaternion.new(
        w * other,
        x * other,
        y * other,
        z * other
      )
    end

    dot_w = w * other.w - dot_product(other)
    cross_x = y * other.z - z * other.y
    cross_y = -(x * other.z - z * other.x)
    cross_z = x * other.y - y * other.x
    Quaternion.new(dot_w, cross_x, cross_y, cross_z) + other.vector * w + vector * other.w
  end

  def ==(other)
    w == other.w && x == other.x && y == other.y && z == other.z
  end

  def conjugate
    Quaternion.new(w, -x, -y, -z)
  end

  def dot_product(other)
    x * other.x + y * other.y + z * other.z
  end

  def inverse
    return nil unless unit?
    conjugate * (1.0 / magnitude_squared)
  end

  def magnitude
    Math.sqrt(magnitude_squared)
  end

  def magnitude_squared
    w * w + x * x + y * y + z * z
  end

  def negative
    Quaternion.new(-w, -x, -y, -z)
  end

  def unit?
    (magnitude - 1).abs <= 0.001
  end

  def vector
    Quaternion.new 0, x, y, z
  end

  def inspect
    "[w = #{w}, x = #{x}, y = #{y}, z = #{z}]"
  end

  def self.one
    Quaternion.new 1, 0, 0, 0
  end

  def self.random(range)
    Quaternion.new(
      rand(range),
      rand(range),
      rand(range),
      rand(range)
    )
  end

  def self.zero
    Quaternion.new 0, 0, 0, 0
  end
end
