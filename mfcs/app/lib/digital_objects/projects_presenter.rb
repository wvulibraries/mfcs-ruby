class DigitalObjects::ProjectsPresenter

    def initialize()
        @projects = Project.all
    end  

    def project_list
        @projects.map do |project|
            {
                id: project.id,
                name: project.name
            }
        end
    end
  
end
  