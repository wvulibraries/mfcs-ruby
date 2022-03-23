class DigitalObjects::FilePresenter

    def initialize(field)
        @filename = field
    end

    def filename
        @filename || 'No File'
    end
  
end
  