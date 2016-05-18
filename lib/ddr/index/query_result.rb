module Ddr::Index
  class QueryResult < AbstractQueryResult
    extend Deprecation

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
      Connection.select(params).docs.each(&block)
    end

    def each_paginated(&block)
      pages.each { |pg| pg.each(&block) }
    end

    def pids
      Deprecation.warn(QueryResult,
                       "`pids` is deprecated; use `ids` instead." \
                       " (called from #{caller.first})"
                      )
      ids
    end

    def ids
      Enumerator.new do |e|
        each do |doc|
          e << doc[Fields::ID]
        end
      end
    end

    def each_pid(&block)
      Deprecation.warn(QueryResult,
                       "`each_pid` is deprecated; use `each_id` instead." \
                       " (called from #{caller.first})"
                      )
      each_id(&block)
    end

    def each_id(&block)
      ids.each(&block)
    end

    def docs
      Enumerator.new do |e|
        each do |doc|
          e << DocumentBuilder.build(doc)
        end
      end
    end

    def objects
      Enumerator.new do |e|
        each_id do |id|
          e << ActiveFedora::Base.find(id)
        end
      end
    end

    def facet_fields
      response = Connection.select(params, rows: 0)
      response.facet_fields.each_with_object({}) do |(field, values), memo|
        memo[field] = Hash[*values]
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
      response = Connection.page(num, page_size, "select", params: page_params)
      response.docs
    end

  end
end
