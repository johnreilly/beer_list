module BeerList
  module Establishments
    class GrovelandTap < Establishment
      URL = 'http://www.grovelandtap.com/beer_taps.php'

      def get_list
        page.search('p.MsoNormal').map(&:text)
      end

      def url
        URL
      end
    end
  end
end
