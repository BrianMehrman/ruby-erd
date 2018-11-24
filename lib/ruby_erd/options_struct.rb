require 'ostruct'

class OptionsStruct < OpenStruct
  require 'optparse'

  def initialize(args = {})
    init_options = {
      all: false,
      include: [],
      exclude: [],
      klasses: [],
      root: '',
      project_dir: 'app',
      config_file: 'config/environment',
      verbose: false
    }
    super(init_options.merge(args))
  end

  def parse(args)
    @opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: #{app_name} [options] command"
      opts.separator ''
      opts.separator 'Common options:'

      opts.on('-i', '--include file1[,fileN]', Array, 'Include only given files') do |list|
        self.include = list
      end

      opts.on('-e', '--exclude file1[,fileN]', Array, 'Exclude given files') do |list|
        self.exclude = list
      end

      opts.on('-k', '--klasses class1[,classN]', Array, 'Names of classes to build a diagram for') do |list|
        self.klasses = list
      end

      opts.on('-v', '--verbose', 'Enable verbose output',
        '  (produce messages to STDOUT)') do |v|
        self.verbose = v
      end

      opts.on('-o', '--output FILE', 'Write diagram to file FILE') do |f|
        self.output = f
      end

      opts.on('-d', '--dir PATH', 'Set PATH as the directory project is in (defaults to app)') do |d|
        self.project_dir = d
      end

      opts.on('-r', '--root PATH', 'Set PATH as the application root') do |r|
        self.root = r
      end

      opts.separator ''
      opts.on('-c', '--config FILE', 'File to load environment (defaults to config/environment)') do |c|
        self.config_file = c if c && c != ''
      end
    end

    begin
      @opt_parser.parse!(args)
    rescue OptionParser::AmbiguousOption
      option_error 'Ambiguous option'
    rescue OptionParser::InvalidOption
      option_error 'Invalid option'
    rescue OptionParser::InvalidArgument
      option_error 'Invalid argument'
    rescue OptionParser::MissingArgument
      option_error 'Missing argument'
    end
  end

  private

  def option_error(msg)
    STDERR.print "Error: #{msg}\n\n #{@opt_parser}\n"
    exit 1
  end
end
