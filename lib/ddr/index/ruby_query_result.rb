module Ddr::Index
  class RubyQueryResult < QueryResult
    include Enumerable

    def each(&block)
      if params[:rows]
        each_unpaginated(&block)
      else
        each_paginated(&block)
      end
    end

    def each_unpaginated
      _params = {rows: MAX_ROWS}.merge(params)
      response = conn.select(_params)
      response.docs.each { |doc| yield(doc) }
    end

    def each_paginated
      pages.each do |pg|
        pg.each do |doc|
          yield doc
        end
      end
    end

    def pids
      each do |doc|
        yield doc[Fields::PID]
      end
    end

    def docs
      each do |doc|
        yield DocumentBuilder.build(doc)
      end
    end

    def all
      to_a
    end

    def pages
      num = 1
      Enumerator.new do |enum|
        loop do
          pg = page(num)
          enum << pg
          if pg.has_next?
            num += 1
          else
            break
          end
        end
      end
    end

    def page(num)
      response = conn.page num, PAGE_SIZE, "select", params: params
      response.docs
    end

  end
end
