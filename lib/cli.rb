class CommandLine
    
    PROMPT = TTY::Prompt.new

    @@user = nil

    def run 
        welcome
        login
        menu
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
                password = PROMPT.mask("Password:")
            end 
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
    end

    # Asks user whether they want to log in or sign up
    def login_prompt 
        PROMPT.select("Would you like to log in or sign up?", ["Login", "Sign up"])
    end 

    # Allows the user to sign up for a new account
    def signup
        username = PROMPT.ask("Create a username:")
        password = PROMPT.mask("Create a password:")
        @@user = User.create(name: username, password: password)
    end 

    def menu 
        choice = PROMPT.select("Main Menu") do |menu|
            menu.choice "Act Now!" #can choose between friend, family, stranger, gives a kindact
            menu.choice "Share Reflections"
            menu.choice "View Past Actions"
            menu.choice "Add Friend or Family Member" #adds a recipient
            menu.choice "View Profile" #can view the success rate, streak, etc.
            menu.choice "Exit"
        end
    if choice == "Act Now!"
        act_now
    elsif choice == "Exit"
            exit
        end
    end

    def act_now 

    end 
end 