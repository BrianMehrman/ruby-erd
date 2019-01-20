module RubyErd
  class Klass
    include RubyErd::SourceLocation

    attr_reader :klass, :options

    def self.extract(filename)

    end

    def initialize(klass, options)
      @klass = klass
      @options = options
      @nodes = []
      @edges = []
    end

    def walk
      puts "class: #{klass.name}" if @options.verbose
      @nodes << ['class', klass.name] if klass.name
      walk_parent
      walk_modules
      return @nodes, @edges
    end

    def walk_modules
      _modules.each do |m|
        _m = KModule.new(m, options)

        # if _m.in_project?
          nodes, edges = _m.walk
          @nodes += nodes if !nodes.nil?
          @edges += edges if !edges.nil?

          @edges << ['includes', m.name, klass.name] if m.name && klass.name
        # end
      end
    end

    def walk_parent
      _parent = Klass.new(klass.superclass, options)

      if _parent.in_project?
        nodes, edges =  _parent.walk

        @nodes += nodes if !nodes.nil?
        @edges += edges if !edges.nil?
        @edges << ['is-a', klass.superclass.name, klass.name] if klass.name && klass.superclass.name
      end
    end

    def in_project?
      (singleton_files + instance_files).detect { |f| file_in_project?(f) }
    end

    private

    def file_in_project?(f)
      path = Pathname.new(f)
      path.fnmatch?(File.join(Dir.pwd, '**'))
    end

    def _modules
      _ancestors = klass.ancestors
      _idx = _ancestors.index(klass.superclass)

      return [] if _idx.nil? || _idx < 2

      _ancestors.slice(1, _idx).select { |m| m.class == Module }
    end

  end
end
