#!/usr/bin/env ruby
#
#  sample script of TkOptionDB
#
#  If 'LANG' environment variable's value is started by 'ja',  
#  then read Japanese resource data and display Japanese button text. 
#  In other case, read English resource data and display English text. 
#
require "tk"

if ENV['LANG'] =~ /^ja/
  # read Japanese resource
  TkOptionDB.readfile(File.expand_path('resource.ja', File.dirname(__FILE__)))
else
  # read English resource
  TkOptionDB.readfile(File.expand_path('resource.en', File.dirname(__FILE__)))
end

# 'show_msg' and 'bye_msg' procedures can be defined on BTN_CMD resource.
# Those procedures are called under $SAFE==2
cmd = TkOptionDB.new_proc_class(:BTN_CMD, [:show_msg, :bye_msg], 2) {
  # If you want to check resource string (str), 
  # please define __check_proc_string__(str) like this.
  class << self
    def __check_proc_string__(str)
      print "($SAFE=#{$SAFE}) check!! str.tainted?::#{str.tainted?}"
      str.untaint
      print "==>#{str.tainted?} : "
      str
    end
  end
}

TkFrame.new(:class=>'BtnFrame'){|f|
  pack(:padx=>5, :pady=>5)
  TkButton.new(:parent=>f, :widgetname=>'hello'){ 
    command proc{
      print "($SAFE=#{$SAFE}) : "
      cmd.show_msg(TkOptionDB.inspect)
    } 
    pack(:fill=>:x, :padx=>10, :pady=>10)
  }
  TkButton.new(:command=>proc{print "($SAFE=#{$SAFE}) : "; cmd.bye_msg; exit}, 
	       :parent=>f, :widgetname=>'quit'){
    pack(:fill=>:x, :padx=>10, :pady=>10)
  }
}

Tk.mainloop
