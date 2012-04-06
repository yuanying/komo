require 'komo'

class Komo::Resource
  include DataMapper::Resource

  property :id,         Serial
  property :title,      String
  property :body,       Text

  property :path,       String
  property :created_at, DateTime
end
