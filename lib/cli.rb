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
        choice = PROMPT.select("Would you like to log in or sign up?", ["Login", "Sign up"])
        if choice == "Login"
            username = PROMPT.ask("Username:")
            user = User.find_by(name: username)
            @@user = user
        elsif choice == "Sign up"
            signup
        end 
    end

    #Allows the user to sign up for a new account
    def signup
        username = PROMPT.ask("Create a username:")
        password = PROMPT.mask("Create a password:")
        @@user = User.create(name: username, password: password)
    end 

end 