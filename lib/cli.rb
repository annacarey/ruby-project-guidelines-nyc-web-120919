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
                if @@user.password == password
                    @@user = user
                else 
                    PROMPT.error("Incorrect password")
                    PROMPT.keypress("Try again")
                    puts "\n"
                    login
                end 
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

    # Shows menu options
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
    elsif choice == "Share Reflections"
        get_reflections
    elsif choice == "Exit"
            exit
    end
        puts "\n"
    end

    # Shows the user the random act to take on and allows user to get a new one if they want
    def act_now
        puts "\n"
        act = get_random_act
        PROMPT.say(act.description)
        puts "\n"
        choice = PROMPT.select("Ready to take this on?", ["Hell yes!", "Pick again", "Return to Menu"])
        if choice == "Hell yes!"
            Action.create(description: act.description, user_id: @@user.id, kindact_id: act.id)
            puts "\n"
            PROMPT.ok("Congrats for taking this on! Log back in later to let us know what happened!")
            puts "\n"
            PROMPT.keypress("Return to menu")
            system "clear"
            menu 
        elsif choice == "Pick again"
            act_now
        elsif choice == "Return to Menu"
            menu
        end
    end

    # Gets a random act of kindness
    def get_random_act
        KindAct.all.sample
    end 

    # Prompts user to share whether or not they completed the action and their written reflections
    def get_reflections
        last_action = Action.where(user_id: @@user.id).last
        puts "\n"
        PROMPT.say("Your last task:" + "\n" + last_action.description + "\n")
        puts "\n"
        last_action.completion = PROMPT.yes?("Did you complete it?")
        puts "\n"
        last_action.reflection = PROMPT.ask("How did it go? (What happened? How did you feel during and after? Did you get any feedback from the other person?)")
        puts "\n"
        PROMPT.ok("Thank you for sharing your reflections!")
        PROMPT.keypress("Return to menu")
        menu 
    end 

end 