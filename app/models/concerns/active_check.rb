module ActiveCheck
  def active?
    t = Time.zone.now

    if self.starts_at && self.ends_at
      return t >= self.starts_at && t < self.ends_at
    end

    return t >= self.starts_at if self.starts_at
    return t < self.ends_at if self.ends_at
    return false
  end
end
