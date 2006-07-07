
Ym4r::GmPlugin::GPolyline.class_eval do
  #Creates a GPolyline object from a georuby line string. Assumes the points of the line strings are stored in Longitude(x)/Latitude(y) order.
  def self.from_georuby(line_string,color = nil,weight = nil,opacity = nil)
    GPolyline.new(line_string.points.collect { |point| GLatLng.new([point.y,point.x])},color,weight,opacity)
  end
end

Ym4r::GmPlugin::GMarker.class_eval do
  #Creates a GMarker object from a georuby point. Accepts the same options as the GMarker constructor. Assumes the points of the line strings are stored in Longitude(x)/Latitude(y) order.
  def self.from_georuby(point,options = {})
    GMarker.new([point.y,point.x],options)
  end
end

Ym4r::GmPlugin::GLatLng.class_eval do
  #Creates a GLatLng object from a georuby point. Assumes the points of the line strings are stored in Longitude(x)/Latitude(y) order.
  def self.from_georuby(point,unbounded = nil)
    GLatLng.new([point.y,point.x],unbounded)
  end
end

