module RubyErd
  module SourceLocation
    def instance_files
      local_instance_methods.map { |m| instance_source_location(m) }.compact
    end

    def singleton_files
      local_singleton_methods.map { |m| singleton_source_location(m) }.compact
    end

    def singleton_source_location(m)
      klass.method(m)&.source_location&.first
    end

    def instance_source_location(m)
      klass.instance_method(m)&.source_location&.first
    end

    def local_instance_methods
      @instance_methods ||= parse_instance_methods
    end

    def local_singleton_methods
      @singleton_methods ||= parse_singleton_methods
    end

    private

    def parse_instance_methods
      klass.instance_methods - klass&.superclass&.instance_methods
    end

    def parse_singleton_methods
      klass.singleton_methods - klass&.superclass&.instance_methods
    end
  end
end
