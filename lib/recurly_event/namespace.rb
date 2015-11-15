module RecurlyEvent
  class Namespace < Struct.new(:namespace, :delimeter)
    RESOURCES_REGEXP = /account|billing_info|invoice|subscription|payment|refund/

    def with_namespace(name)
      "#{namespace}#{delimeter}#{name}"
    end

    def parse_with_namespace(name)
      with_namespace(parse_name(name))
    end

    def regexp_wrap(name)
      /^#{Regexp.escape(with_namespace(name))}/
    end

  private

    def parse_name(name)
      noun = RESOURCES_REGEXP.match(name).to_s
      splitted = name.gsub("#{noun}_", "").split("_")
      splitted.pop
      verb = splitted.join("_")
      "#{noun}.#{verb}"
    end
  end
end
