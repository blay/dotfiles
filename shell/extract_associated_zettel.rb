#!/usr/local/env ruby

#  Usage: extract_associated_zettel.rb [options] FILE
#      -d, --depth [DEPTH]              How many levels to traverse before aborting. Default is 10.
#      -o, --output [OUTPUT]            OUTPUT file to store the graphviz dot output instead of stdout
#      -v, --verbose                    Print debug info to stdout. Only works with -o/--output to re-route result
#      -h, --help                       Prints this help

require "optparse"

module Launch
  REQUIRED_OPTIONS = []

  def self.options
    options = {}
    parser = OptionParser.new do |o|
      o.banner = "Usage: #{__FILE__} [options] FILE"

      options[:depth] = 10
      o.on("-d", "--depth [DEPTH]", :OPTIONAL, "How many levels to traverse before aborting. Default is #{options[:depth]}.") do |val|
        options[:depth] = val&.to_i || options[:depth]
      end
      
      options[:output] = nil
      o.on("-o", "--output [OUTPUT]", :OPTIONAL, "OUTPUT file to store the graphviz dot output instead of stdout") do |val|
        raise "OUTPUT value missing" if val.nil?
        path = File.expand_path(val)
        raise "Directory for #{path} does not exist." unless File.exists?(File.dirname(path))
        options[:output] = path
      end

      options[:verbose] = false
      o.on_tail("-v", "--verbose", "Print debug info to stdout. Only works with -o/--output to re-route result") do
        options[:verbose] = true
      end

      o.on_tail("-h", "--help", "Prints this help") do
        puts o
        exit
      end
    end
    parser.parse!

    options[:verbose] = false if options[:verbose] && options[:output].nil? 
    
    # Show standard error when required keys are missing. OptionParser should do this on its own, but apparently doesn't.
    missing_required = REQUIRED_OPTIONS - options.keys
    raise OptionParser::MissingArgument.new(missing_required) unless missing_required.empty?

    return options
  end
end

class Archive
  def initialize(directory_path)
    @directory_path = directory_path
  end

  def text_file(filename)
    TextFile.new(File.join(@directory_path, filename))
  end
end

class TextFile
  attr_reader :path
  
  def initialize(path)
    @path = path
  end

  def ==(other)
    self.path == other.path
  end

  def filename
    File.basename(@path)
  end
  
  def directory_path
    File.dirname(@path)
  end

  def archive
    Archive.new(directory_path)
  end

  def contents
    @contents ||= read_contents
  end

  def read_contents
    File.read(@path)
  end

  def zettel
    @zettel ||= Zettel.new(self.contents)
  end
end

class Zettel
  def initialize(contents)
    @contents = contents
  end

  def link_targets
    @link_targets ||= @contents.all_matches(/\[\[(.+?)\]\]/).flatten
  end
end

class String
  def all_matches(regexp)
    rest = self
    result = []
    while m = rest.match(regexp)
      result << m.captures
      rest = m.post_match
    end
    return result
  end
end

class KnownTextFiles
  def all
    @all ||= []
  end

  def include?(text_file)
    all.include?(text_file)
  end
  
  def <<(text_file)
    return if all.include?(text_file)
    all << text_file
  end
end

class ArchiveCrawler
  attr_reader :all_files
  
  def initialize(directory_path)
    @directory_path = directory_path
    @all_files ||= Dir.children(@directory_path)
  end

  def best_match(link)
    link = link.downcase
    result = @all_files.filter { |elem| elem.downcase.start_with?(link) }.sort.first
    result = result || @all_files.filter { |elem| elem.downcase.include?(link) }.sort.first
    return result
  end

  def crawl(text_file, callback, options)
    @crawled_filenames = KnownTextFiles.new()
    _crawl(text_file, callback, options[:verbose], level=1, options[:depth])
    @crawled_filenames = nil
  end
  
  private 
  def _crawl(source, callback, verbose, level, max_level)
    return if level > max_level

    _i = indent(level)
    
    source.zettel.link_targets.each do |link|
      unless (filename = best_match(link)).nil?
        target = source.archive.text_file(filename)
        callback.call(source, target)
        unless @crawled_filenames.include?(target)
          puts "#{_i}#{filename}" if verbose
          @crawled_filenames << target
          _crawl(target, callback, verbose, level + 1, max_level)
        else
          puts "#{_i}#{filename} (duplicate contents skipped)" if verbose
        end
      else
        puts "#{_i}not found: `#{link}`" if verbose
      end
    end
  end

  def indent(level)
    indentation = "  "*level
  end
end

module Graphviz
  Node = Struct.new(:label, :name) do
    MAX_LINE_LENGTH = 15
    def definition
      lines = [[]]
      label.split(" ").each do |word|
        lines.last << word
        if lines.last.join(" ").length >= MAX_LINE_LENGTH
          lines << []
        end
      end
      label = lines.map { |l| l.join(" ") }.join("\\n").rstrip
      %Q{#{name}[label="#{label}"];}
    end
  end

  Connection = Struct.new(:from, :to) do
    def output
      "#{from} -> #{to};"
    end
  end
  
  class Diagram
    def add_connection(from, to)
      @connections ||= []
      @connections << Connection.new(node(from), node(to))
    end

    def node(label)
      @nodes ||= {}
      @nodes[label] ||= _node_name(@nodes.count)
    end

    def _node_name(i)
      i
    end

    #def _node_names
    #  @_node_names ||= ("a".."zzzz").to_a
    #end

    def options
      { rankdir: "LR",
        overlap: "false",
        splines: "false" }
    end

    def output
      lines = []
      lines << "digraph {"
      options.each do |k, v|
        lines << "  #{k.to_s}=#{v.to_s};"
      end
      lines << "  node [shape=box];"

      # Node label definitions
      @nodes.each do |label, name|
        node = Node.new(label, name)
        lines << "  " + node.definition
      end

      # Node connections
      @connections.each do |conn|
        lines << "  " + conn.output
      end

      lines << "}"
    end
  end
end


options = Launch.options
file = ARGV.first
if file.nil?
  STDERR.puts "Missing input FILE"
  exit 1
end

def write_out(options)
  if options[:output]
    File.open(options[:output], "w") do |file|
      yield file
    end
  else
    yield STDOUT
  end
end

origin = TextFile.new(file)
verbose = options[:verbose]
search_dir = origin.directory_path

puts "Searching in `#{search_dir}`, starting with:\n#{origin.filename}" if verbose

if origin.zettel.link_targets.empty?
  write_out(options) do |out|
    out.puts "digraph {}"
  end
  exit
end

diagram = Graphviz::Diagram.new

crawler = ArchiveCrawler.new(search_dir)
crawler.crawl(
  origin,
  ->(source_file, target_file) { diagram.add_connection(source_file.filename, target_file.filename) },
  options)

write_out(options) do |outstr|
  outstr.puts diagram.output
end
