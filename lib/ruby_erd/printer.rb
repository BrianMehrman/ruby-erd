module RubyErd
  class Printer
    def self.print(nodes, edges, output=nil)
      new(nodes, edges, output).print
    end

    def initialize(nodes, edges, output=nil)
      @nodes = nodes
      @edges = edges
      @output = output
    end

    def print
      @result = GraphViz.new(:G, type: :digraph) do |g|
        @nodes.each do |node|
          add_node(g, node[0], node[1])
        end

        @edges.each do |edge|
          add_edge(g, edge[0], edge[1], edge[2])
        end
      end

      @result.output(png: @output || 'a.png')
    end

    def add_node(g, type, name)
      options = {}

      case type
      when 'class'
        options.merge!(shape: 'box')
      when 'module'
        options.merge!(shape: 'box', style: 'dotted')
      end
# binding.pry
      g.add_node(name, **options)
    end

    def add_edge(g, type, from, to)
      options = {}

      case type
      when 'included'
        options.merge!(arrowhead: 'none', arrowtail: 'normal')
      when 'is-a'
        options.merge!(arrowhead: 'none', arrowtail: 'onormal', dir: 'both')
      end

      g.add_edge(from, to, **options)
    end
  end
end
