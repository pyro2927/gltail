module GlTail
  module Source

    class Command < Base
      config_attribute :source, "The type of Source"
      config_attribute :command, "The command to run"
      
        def init
          @lines = []
          Thread.new do #start thread
            begin
              puts "Running command #{command}"
              PTY.spawn( command ) do |stdin, stdout, pid|
                begin
                  # Do stuff with the output here. Just printing to show it works
                  stdin.each { |line|
                    @lines.push(line) 
                  }
                rescue Errno::EIO
                  # puts "Errno:EIO error, but this probably just means " +
                  #                       "that the process has finished giving output"
                end
              end
            rescue PTY::ChildExited
              puts "Command has exited!"
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