module DataMapper
  class Property
    class Raw < String
      length 2000
      
      def primitive?(value)
        true
      end
      
      def custom?
        true
      end
      
      def load(value)
        value
      end
      
      def dump(value)
        value
      end
      
      def typecast_to_primitive(value)
        value
      end
      
    end
    
  end # class Property
end # module DataMapper