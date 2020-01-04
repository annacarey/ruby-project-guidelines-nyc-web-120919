class CommandLine
    
    PROMPT = TTY::Prompt.new

    def run 
        welcome
        login
    end 

    def welcome
        puts "Welcome to the kindess app!"
    end 

end 