#!/usr/bin/ruby
# from https://github.com/andrewsardone/dotfiles/blob/master/ruby/.irbrc

require 'irb/completion'

IRB.conf[:PROMPT_MODE] = :SIMPLE

IRB.conf[:AUTO_INDENT] = true

class Object
  def local_methods
    (methods - Object.instance_methods).sort
  end

  # print documentation
  #
  #   ri 'Array#pop'
  #   Array.ri
  #   Array.ri :pop
  #   arr.ri :pop
  def ri(method = nil)
    unless method && method =~ /^[A-Z]/ # if class isn't specified
      klass = self.kind_of?(Class) ? name : self.class.name
      method = [klass, method].compact.join('#')
    end
    puts `ri '#{method}'`
  end
end

# `time` in irb
# via http://ozmm.org/posts/time_in_irb.html
def time(times = 1)
  require 'benchmark'
  ret = nil
  Benchmark.bm { |x| x.report { times.times { ret = yield } } }
  ret
end
