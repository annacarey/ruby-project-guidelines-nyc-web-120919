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
        system "clear"
        choice = PROMPT.select("Main Menu") do |menu|
            menu.choice "Act Now!" #can choose between friend, family, stranger, gives a kindact
            menu.choice "Share Reflections"
            menu.choice "View Past Actions"
            menu.choice "Add Friend or Family Member" #adds a recipient
            menu.choice "Manage Profile" #can view the success rate, streak, etc.
            menu.choice "Exit"
        end
    if choice == "Act Now!"
        act_now
    elsif choice == "Share Reflections"
        get_reflections
    elsif choice == "View Past Actions"
        view_past_actions
    elsif choice == "Add Friend or Family Member"
        add_recipient
    elsif choice == "Manage Profile"
        manage_profile
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
        last_action.update(completion: PROMPT.yes?("Did you complete it?"))
        puts "\n"
        if last_action.completion == true 
            last_action.update(reflection: PROMPT.ask("How did it go? (What happened? How did you feel during and after? Did you get any feedback from the other person?)"))
            puts "\n"
            PROMPT.ok("Thank you for sharing your reflections!")
        end 
        PROMPT.keypress("Return to menu")
        menu 
    end 

    # Allows the user to view all of their previous actions and allows them to look at each one individually to see the reflections
    def view_past_actions 
        choice = PROMPT.select("Select the action to view your reflections: \n", get_actions)
        view_reflections(choice)
    end

    # Allows the user to view the reflections of their selected actions
    def view_reflections(choice)
        reflection = Action.find_by(user_id: @@user.id, description: choice).reflection
        if reflection != nil 
            PROMPT.say("\n" + "Reflection:" + "\n" + Action.find_by(user_id: @@user.id, description: choice).reflection)
        else 
            PROMPT.error("This action has no saved reflections.")
        end 
        puts "\n"
        PROMPT.keypress("Return to menu")
        menu 
    end 

    # Helper method to get a list of the users actions in string form 
    def get_actions 
        Action.where(user_id: @@user.id).map do |action|
            action.description 
        end 
    end

    # Allows the user to add a family member to the database
    def add_recipient
        PROMPT.error("Sorry! I haven't implemented this yet")
        PROMPT.keypress("Return to menu")
        menu
    end 

    # Asks the user if they want to change their username, password, or view their performance
    def manage_profile
        choice = PROMPT.select("#{@@user.name}, you can:", ["Change username", "Change password", "View Performance"])
        if choice == "Change username"
            change_username
        elsif choice == "Change password"
            change_password
        elsif choice == "View Performance"
            view_profile
        end 
        puts "\n"
        PROMPT.keypress("Return to menu")
        menu
    end 

    # Allow the user to change their username 
    def change_username 
        password = PROMPT.mask("Please enter your password to change your username")
        if password == @@user.password 
            new_username = PROMPT.ask("New username:")
            @@user.update(name: new_username)
        else 
            PROMPT.error("Your password was entered incorrectly")
            change_username 
        end 
        puts "\n"
        PROMPT.ok("Your new username is #{@@user.name}")
    end 

    # Allow the user to change their password 
    def change_password 
        old_password = PROMPT.mask("Old password:")
        new_password = PROMPT.mask("New password:")
        if new_password == PROMPT.mask("Confirm new password:")
            @@user.update(password: new_password)
        else 
            PROMPT.error("Passwords did not match")
            puts "\n"
            change_password
        end 
        PROMPT.ok("You successfully changed your password!")
    end 

    # Allow the user to view their profile including their username and success rate
    def view_profile
        completed = Action.where(user_id: @@user.id, completion: true)
        if completed != nil 
            completed_count = completed.length
        else 
            completed_count = 0
        end 
        total = Action.where(user_id: @@user.id)
        if total != nil 
            total_count = total.length
        else 
            total_count = 0 
        end 
        PROMPT.say("Hello #{@@user.name}, you have completed #{completed_count} out of #{total_count} total actions.")
    end 

end 