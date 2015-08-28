module Ddr::Index
  class Query

    attr_reader :q, :fields, :filters, :sort, :rows

    delegate :count, :docs, :pids, :each_pid, :all, to: :result

    def inspect
      "#<#{self.class.name} q=#{q.inspect}, filters=#{filters.inspect}," \
      " sort=#{sort.inspect}, rows=#{rows.inspect}, fields=#{fields.inspect}>"
    end

    def to_s
      URI.encode_www_form(params)
    end

    def params
      { q:    q,
        fq:   filters.map(&:clauses).flatten,
        fl:   fields.join(","),
        sort: sort.join(","),
        rows: rows,
      }.select { |k, v| v.present? }
    end

    def result
      QueryResult.new(self)
    end

    def csv(**opts)
      CSVQueryResult.new(self, **opts)
    end

  end
end
