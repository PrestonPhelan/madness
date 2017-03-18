class MathUtil
  def self.cdf(z)
    0.0 if z < -12
    1.0 if z > 12
    0.5 if z == 0.0

    if z > 0.0
      e = true
    else
      e = false
      z = -z
    end
    z = z.to_f
    z2 = z * z
    t = q = z * Math.exp(-0.5 * z2) / Math.sqrt(2 * Math::PI)

    3.step(199, 2) do |i|
      prev = q
      t *= z2 / i
      q += t
      if q <= prev
        return(e ? 0.5 + q : 0.5 - q)
      end
    end
    e ? 1.0 : 0.0
  end
end
