echo "Preparing Database"
bin/rails db:create
bin/rails db:schema:load
bin/rails db:seed

echo "Importing Users"
bin/rails r importing/users/import_users.rb 
echo "Importing Projects"
bin/rails r importing/projects/import_projects.rb 
echo "Importing Watermarks"
bin/rails r importing/watermarks/import_watermarks.rb 
echo "Importing Forms"
bin/rails r importing/forms/import_forms.rb 
echo "Importing Objects"
bin/rails r importing/objects/import.rb 
