# frozen_string_literal: true

require 'matrix'

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

  def angle(delta: 0.001, step: Math::PI / 36_000.0)
    raise 'Non-unit quaternions have no angles' unless unit?
    current = -Math::PI
    max = Math::PI

    while current < max
      cos = Math.cos(current)
      sin = Math.sin(current)
      cos_pass = (cos * cos - w * w).abs <= delta
      sin_pass = (sin * sin - vector.magnitude_squared).abs <= delta
      if cos_pass && sin_pass
        positive_angle = current.negative? ? Math::PI + current : current
        return positive_angle
      end
      current += step
    end

    nil
  end

  def column_vector
    Matrix.column_vector [w, x, y, z]
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

  def matrix
    Matrix[
      [w, -x, -y, -z],
      [x, w, -z, y],
      [y, z, w, -x],
      [z, -y, x, w]
    ]
  end

  def negative
    Quaternion.new(-w, -x, -y, -z)
  end

  def pure?
    w.abs <= 0.001
  end

  def rotate(other)
    raise 'Rotation quaternion must be a unit quaternion' unless unit?
    raise 'Quaternion to rotate must be pure' unless other.pure?
    self * other * conjugate
  end

  def unit
    self * (1.0 / magnitude)
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

  def self.angle_axis(angle, axis)
    axis * Math.sin(angle) + Math.cos(angle)
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

  alias normalize unit
  singleton_class.send(:alias_method, :unit, :one)
end
