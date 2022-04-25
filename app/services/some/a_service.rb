module Some
  class AService
    include ActiveModel::AttributeMethods

    def initialize(num)
      @num = num
    end

    def perform
      @num * @num
    end
  end
end
