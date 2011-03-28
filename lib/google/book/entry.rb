require 'bookland'
require 'google/book/cover'

module Google
  module Book
    class Entry
      def initialize(hash)
        @hash = hash
      end

      def cover
        Cover.new(@hash['link'][0]['href'])
      end

      def creators
        [@hash['dc:creator']].flatten.join(', ')
      end

      def date
        @hash['dc:date']
      end

      def description
        @hash['dc:description']
      end

      def format
        [@hash['dc:format']].flatten.reject do |format|
          format == 'book'
        end.join(', ')
      end

      def info_url
        @hash['link'][1]['href']
      end

      def preview_url
        @hash['link'][2]['href']
      end

      def publisher
        @hash['dc:publisher'].
          gsub(/[ ,]+Inc.?$/, '').
          gsub(/[ ,]+Llc.?$/i, '').
          gsub(/[ ,]+Ltd.?$/, '').
          gsub(/Intl( |$)/) { "International#{$1}" }.
          gsub(/Pr( |$)/) { "Press#{$1}" }.
          gsub(/ Pub$/, ' Publishers').
          gsub(/ Pubns$/, ' Publications').
          gsub('Pub Group', 'Publishing Group').
          gsub(/Univ( |$)/) { "University#{$1}" }
      end

      def subjects
        @hash['dc:subject']
      end

      def title
        [@hash['dc:title']].flatten.join(': ')
      end

      def isbn
        @hash['dc:identifier'].detect do |identifier|
          identifier.match(/ISBN:([0-9X]{10,13})/)
        end

        ISBN.to_13($1) rescue nil
      end
    end
  end
end
