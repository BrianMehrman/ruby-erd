module RubyErd
  class Generator
    attr_reader :klasses, :files

    def initialize(options)
      @options = options
      @klasses = options.klasses
      @nodes   = []
      @edges   = []
    end

    def process
      load_project
      load_environment
    end

    def generate
      STDERR.puts 'Generating class diagram' if @options.verbose
      _klasses = klasses
      _klasses ||= get_klasses(@options.project_dir)

      (_klasses).each do |klass_name|
        begin
          klass_name
          klass = Object.const_get klass_name
          process_class(klass)
        rescue Exception => e
          STDERR.puts "Warning: exception `#{e.message}` raised while trying to load model class #{klass_name}"
        end
      end
    end

    def print
      Printer.print(@nodes, @edges, @options.output)
    end

    private

    def process_class(current_class)
      STDERR.puts "Processing #{current_class}" if @options.verbose

      klass =  Klass.new(current_class, @options)

      if klass.in_project?
        nodes, edges = klass.walk

        @nodes += nodes if !nodes.nil?
        @edges += edges if !edges.nil?
      end
    end

    def load_project
      lib = @options.project_dir
      $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
    end

    def load_environment
      STDERR.print "Loading application environment\n" if @options.verbose
      begin
        disable_stdout
        l = File.join(Dir.pwd.to_s, @options.config_file)
        require l
        enable_stdout
      rescue LoadError
        enable_stdout
        print_error 'application environment'
        raise
      end
      STDERR.print "Loading application classes as we go\n" if @options.verbose
    end

    def print_error(type)
      STDERR.print "Error loading #{type}.\n  (Are you running " \
                   "#{@options.app_name} on the application's root directory?)\n\n"
    end

    def get_klasses(prefix)
      get_files(prefix).map do |f|
        extract_class_name(f)
      end
    end

    def get_files(prefix = '')
      files = !@options.include.empty? ? Dir.glob(@options.included) : Dir.glob("#{prefix}/**.rb")
      files -= Dir.glob(@options.exclude)
      files
    end

    # Extract class name from filename
    def extract_class_name(filename)
      # filename.split('/')[2..-1].join('/').split('.').first.camelize
      # Fixed by patch from ticket #12742
      # File.basename(filename).chomp(".rb").camelize
      filename.split('/')[2..-1].collect(&:camelize).join('::').chomp('.rb')
    end

     # Prevents Rails application from writing to STDOUT
     def disable_stdout
      @old_stdout = STDOUT.dup
      # via  Tomas Matousek, http://www.ruby-forum.com/topic/205887
      STDOUT.reopen(::RUBY_PLATFORM =~ /djgpp|(cyg|ms|bcc)win|mingw/ ? 'NUL' : '/dev/null')
    end

    # Restore STDOUT
    def enable_stdout
      STDOUT.reopen(@old_stdout)
    end
  end
end
