module Resque
  class << self
    def enqueue(klass, *args)
      true
    end
  end
end
