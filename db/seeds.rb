# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
ext = "yml"
filepaths = Dir.glob(File.dirname(__FILE__) + "/fixtures/*." + ext)
filepaths.each do | filepath |
  fixture = File.read("#{filepath}")
  data = YAML.load(ERB.new(fixture).result)
  tablename = File.basename filepath,  "." + ext
  modelname = tablename.classify
  (modelname.constantize).create(data.values)
end