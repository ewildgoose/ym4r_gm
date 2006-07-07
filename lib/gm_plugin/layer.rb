module Ym4r
  module GmPlugin
    #Map types of the map
    class GMapType
      include MappingObject
      
      G_NORMAL_MAP = Variable.new("G_NORMAL_MAP")
      G_SATELLITE_MAP = Variable.new("G_SATELLITE_MAP")
      G_HYBRID_MAP = Variable.new("G_HYBRID_MAP")
      
      attr_accessor :layers, :name, :projection, :options
      
      def initialize(layers, name, projection = GMercatorProjection.new,options = {})
        @layers = layers
        @name = name
        @projection = projection
        @options = options
      end

      def create
        "new GMapType(#{MappingObject.javascriptify_variable(Array(layers))}, #{MappingObject.javascriptify_variable(projection)}, #{MappingObject.javascriptify_variable(name)}, #{MappingObject.javascriptify_variable(options)})"
      end
    end

    class GMercatorProjection
      include MappingObject
      
      attr_accessor :n
      
      def initialize(n = nil)
        @n = n
      end

      def create
        if n.nil?
          return "G_NORMAL_MAP.getProjection()"
        else
          "new GMercatorProjection(#{@n})"
        end
      end
    end

    class GTileLayer
      include MappingObject
            
      attr_accessor :opacity, :zoom_inter, :copyright, :format

      def initialize(zoom_inter = 0..17, copyright= {'prefix' => '', 'copyright_texts' => [""]}, opacity = 1.0, format = "png")
        @opacity = opacity
        @zoom_inter = zoom_inter
        @copyright = copyright
        @format = format.to_s
      end

      def create
        "addPropertiesToLayer(new GTileLayer(new GCopyrightCollection(\"\"),#{zoom_inter.begin},#{zoom_inter.end}),#{get_tile_url},function(a,b) {return #{MappingObject.javascriptify_variable(@copyright)};}\n,function() {return #{@opacity};},function(){return #{@format == "png"};})"
      end
      
      #for subclasses to implement
      def get_tile_url
      end
    end
    
    #Represents a pre tiled layer, taking images directly from a server, without using a server script.
    class PreTiledLayer < GTileLayer
      attr_accessor :base_url
      
      def initialize(base_url = "/public/tiles", copyright = {'prefix' => '', 'copyright_texts' => [""]}, zoom_inter = 0..17, opacity = 1.0,format = "png")
        super(zoom_inter, copyright, opacity,format)
        @base_url = base_url
      end
      
      #returns the code to determine the url to fetch the tile. Follows the convention adopted by the tiler: {base_url}/tile_{b}_{a.x}_{a.y}.{format}
      def get_tile_url
        "function(a,b,c) { return '#{@base_url}/tile_' + b + '_' + a.x + '_' + a.y + '.#{format}';}"
      end 
    end

    #Represents a pretiled layer (it actually does not really matter where the tiles come from). Calls an action on the server to get back the tiles. It can be used, for example, to return default tiles when the requested tile is not present.
    class PreTiledLayerFromAction < PreTiledLayer
      def get_tile_url
        "function(a,b,c) { return '#{base_url}?x=' + a.x + '&y=' + a.y + '&z=' + b;}"
      end
    end
    
    #needs to include the JavaScript file wms-gs.js for this to work
    #see http://docs.codehaus.org/display/GEOSDOC/Google+Maps
    class WMSLayer < GTileLayer
      attr_accessor :base_url, :layers, :styles, :merc_proj, :use_geographic

      def initialize(base_url, layers, styles = "", copyright = {'prefix' => '', 'copyright_texts' => [""]}, use_geographic = false, merc_proj = :mapserver, zoom_inter = 0..17, opacity = 1.0,format= "png")
        super(zoom_inter, copyright, opacity,format)
        @base_url = base_url
        @layers = layers
        @styles = styles
        @merc_proj = if merc_proj == :mapserver
                       "54004"
                     elsif merc_proj == :geoserver
                       "41001"
                     else
                       merc_proj.to_s
                     end
        @use_geographic = use_geographic
      end
      
      def get_tile_url
        "getTileUrlForWMS"
      end

      def create
        "addWMSPropertiesToLayer(#{super},#{MappingObject.javascriptify_variable(@base_url)},#{MappingObject.javascriptify_variable(@layers)},#{MappingObject.javascriptify_variable(@styles)},#{MappingObject.javascriptify_variable(format)},#{MappingObject.javascriptify_variable(@merc_proj)},#{MappingObject.javascriptify_variable(@use_geographic)})"
      end
    end
  end
end
