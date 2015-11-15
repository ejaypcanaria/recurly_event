module RecurlyEvent
  class Namespace < Struct.new(:namespace, :delimeter)
    def with_namespace(name)
      "#{namespace}#{delimeter}#{name}"
    end

    def regexp_wrap(name)
      /^#{Regexp.escape(with_namespace(name))}/
    end
  end
end
