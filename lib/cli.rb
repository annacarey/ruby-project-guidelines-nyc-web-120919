class CommandLine
    
    PROMPT = TTY::Prompt.new

    @@user = nil

    def run 
        welcome
        login
        #menu
    end 

    # Prints welcome message to the user
    def welcome
        PROMPT.say("Welcome to the kindess app!")
    end 

    # Allows user to login or sign up
    def login
        choice = login_prompt
        if choice == "Login"
            username = PROMPT.ask("Username:")
     
            user = User.find_by(name: username)
            if user == nil
                PROMPT.error("Username not found")
                PROMPT.keypress("Try again")
                puts "\n"
                login
            else 
                @@user = user 
            end 
            password = PROMPT.mask("Password:")
            if @@user.password == password
                @@user = user
            else 
                PROMPT.error("Incorrect password")
                PROMPT.keypress("Try again")
                puts "\n"
                login
            end 
        elsif choice == "Sign up"
            signup
        end 
        binding.pry
    end

    def login_prompt 
        PROMPT.select("Would you like to log in or sign up?", ["Login", "Sign up"])
    end 

    #Allows the user to sign up for a new account
    def signup
        username = PROMPT.ask("Create a username:")
        password = PROMPT.mask("Create a password:")
        @@user = User.create(name: username, password: password)
    end 

end 