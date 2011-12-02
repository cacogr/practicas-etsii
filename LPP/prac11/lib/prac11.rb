#!/usr/bin/env ruby

class HTML
  attr_accessor :page

  def initialize(&block)
    @page = [[]]
    instance_eval &block
  end

  def build_attr(attributes)
      return "" if attributes.nil? or attributes.empty?
      attributes.inject("") {|s,y| s << %{ #{y[0]}="#{y[1]}"}}
  end

  def method_missing(tag, *args)
    text = ""
    if block_given?
      @page.push []
      yield
      text = @page.pop.join(' ')
    else
      text = args.shift
    end
    textattr = build_attr(args.shift)
    text = "<#{tag} #{textattr}> #{text} </#{tag}> \n"
    @page[-1].push text
    text
  end

  def to_s
    @page.join('\n')
  end
end

if __FILE__ == $0
  q = HTML.new {
    html {
      head(:dir => "chazam", :lang => "spanish") { title "My wonderful home page" }
      body do
        h1 "Welcome to my home page!", :class => "chuchu", :lang => "spanish"
        b "My hobbies:"
        ul do
          li "Juggling"
          li "Knitting"
          li "Metaprogramming"
        end #ul
      end # body
    }
  }
  puts q
end
