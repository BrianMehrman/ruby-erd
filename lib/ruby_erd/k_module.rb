module RubyErd
  class KModule
    include RubyErd::SourceLocation

    attr_reader :kmodule, :options

    def initialize(kmodule, options)
      @options = options
      @nodes = []
      @edges = []
      @kmodule = kmodule
    end

    def walk
      puts "Processing module: #{klass.name}" if @options.verbose

      @nodes << ['module', kmodule.name] if kmodule.name

      _modules.each do |m|
        @nodes << ['module', m.name] if m.name
        @edges << ['includes', m.name, kmodule.name] if m.name && kmodule.name
      end

      return @nodes, @edges
    end

    private

    def _modules
      _ancestors = kmodule.ancestors

      return [] if _ancestors.size < 2

      _ancestors.slice(1, _ancestors.size - 1)
    end
  end
end
