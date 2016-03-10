module Ddr::Index
  class QueryResult < AbstractQueryResult

    PAGE_SIZE = 1000

    delegate :csv, to: :query

    def each(&block)
      if params[:rows]
        each_unpaginated(&block)
      else
        each_paginated(&block)
      end
    end

    def each_unpaginated(&block)
      conn.select(params).docs.each(&block)
    end

    def each_paginated(&block)
      pages.each { |pg| pg.each(&block) }
    end

    def pids
      Enumerator.new do |e|
        each do |doc|
          e << doc[Fields::ID]
        end
      end
    end

    def each_pid(&block)
      pids.each(&block)
    end

    def docs
      Enumerator.new do |e|
        each do |doc|
          e << DocumentBuilder.build(doc)
        end
      end
    end

    def all
      to_a
    end

    def pages
      num = 1
      Enumerator.new do |e|
        loop do
          pg = page(num)
          e << pg
          unless pg.has_next?
            break
          end
          num += 1
        end
      end
    end

    def page(num)
      page_params = params.dup
      page_size = page_params.delete(:rows) || PAGE_SIZE
      response = conn.page num, page_size, "select", params: page_params
      response.docs
    end

  end
end
