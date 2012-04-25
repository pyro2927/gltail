require 'pty'
module GlTail
  module Source

    class TShark < Base
      config_attribute :source, "The type of Source"

        def init
          @lines = []
          Thread.new do #start thread
            begin
              PTY.spawn( "tshark" ) do |stdin, stdout, pid|
                begin
                  # Do stuff with the output here. Just printing to show it works
                  stdin.each { |line|
                    if(line.include?('DNS Standard query A'))
                      @lines.push(line) 
                    end
                  }
                rescue Errno::EIO
                  # puts "Errno:EIO error, but this probably just means " +
                  #                       "that the process has finished giving output"
                end
              end
            rescue PTY::ChildExited
              puts "Tshark has exited!"
            end
          end #end thread
        end
      
        def process
          unless @lines.length == 0
            parser.parse(@lines[0]) 
            @lines.delete_at(0)
          end
        end
        
        def update
        end
        
    end
  end
end