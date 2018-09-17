$preword = "termworld> "
def twputs o
  print "\e[34m#{$preword}\e[0m"
  puts o
end
def tweputs o
  print " " * $preword.length
  puts o
end

def green o
  "\e[32m#{o}\e[0m"
end
