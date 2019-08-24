# WhatsIngredient
WhatsIngredient is an app that allows users to take pictures of their food and identify if there is any ingredients in the picture that is in user's watchlist. 

# Feature List
- Flexible UI built with Auto Layout
- Firebase for API side operation and data storage
- Clarifai for image analyzation 
- RecipePuppy for recipe API

# Getting started
If you're a developer hoping to make changes to my code or just wants to play around with it you can type the command below in your terminal:
```
git clone https://github.com/calee14/FoodAllergyIndicator.git
```
If you want to use the app you can download it on the App Store. [Link will be soon available](). May expect some delays due refactoring and the long app store review times. 

# Deployment
It should be intuitive enough to open the app in Xcode and running it on a simulator. 
If you want to use the app you can download it on the App Store. [Link will be soon available](). May expect some delays due refactoring and the long app store review times. 

# Compatibility
- CocoaPods
- Swift 5
- Xcode 10+
- iPhone & iPad

# Built With
- [Clarifai](https://clarifai.com) - Computer Vision API
- [Firebase](https://firebase.google.com) - Backend for mobile apps
- [Xcode](https://developer.apple.com/xcode/) - IDE for iOS app development
- [RecipePuppy](http://www.recipepuppy.com/about/api/) - Recipe API

# Contributors
- **Cap Lee** 

# License
The WhatsIngredient project is available for free use, as described by the [LICENSE](https://github.com/calee14/FoodAllergyIndicator/blob/master/LICENSE) (Apache 2.0).

# Plan of attack
## SUMMER OF 2019
## WEEK 1 and maybe WEEK 2
- [X] Relearn all of my code (know it well enough)
- [X] Reboot the app and make sure all of the code is working
- [X] Redesign the set allergens page (NOTE: Use dummy data for now)
  - [X] Change the name of the button to "set important ingredients"
  - [X] Redesign the set allergens view controller to important ingredients view controller
    - [X] Remove the switch
    - [X] Add the delete button instead 
    - [X] Add a create button to add ingredients to the table
  - [X] Rename some of the variables in the table view and table cell (NOTE: remove the term allergens in most of the views)
## WEEK 2
- [X] Update the database with the user's important ingredients
  - [X] Make new services for updating the users important ingredients
  - [X] Change the name of the services with the word allergens in them (Made new services with new names)
  - [X] Connect the user's ingredients with the database
  - [X] Prettify the set ingredients view controller
  - [X] Change some ui designs for the set ingredients view controller
  - [X] Begin connecting the ingredients to the ai
    - [X] Get the AI to use the ingredients first 
        - [X] Then in week 3 connect the ingredients database
## WEEK 3
- [X] Make the ui improvements
  - [X] add the backgrounds
  - [X] change the app icon
  - [X] Change the button names
  - [X] Make the ui look similar to the flower image recognition app
## WEEK 4 and 5 (final week must ship by then)
- [X] Change the display results view (in progress)
- [X] Need to make sure the ingredients don't get run into the recipe api
  - [X] Get a database and have the app check for ingredients locally
  - [X] Upload an ingredients database to firebase once and use the database from then on
  - [ ] Use a designed api to get ingredients NOTE: least likely
- [X] Make it so that all important ingredients appear at the top of the results page
- [X] Put a confidence score of each ingredient next to it NOTE: no longer putting a confidence score.
- [ ] Display all ingredients from each top recipes when make a request to the recipe api NTOE: still need to connect the recipe api
- [X] Check for memory leaks (found some linked to the camera controller object)
- [ ] Make sure the in app purchase works (change the initial amount of pics to 20)
## WEEK 6
- [ ] Need to make it so that user can sign back into their account.
  - [ ] Create a seperate button for logging in the user which will take them to a different vc
    - [ ] Will need to use Firebase's Authentication API
- [ ] Login screen
- [ ] Login using Firebase Auth API
- [ ] Attempt to sign in anonymously to access data then log out when done
- [ ] Add user email to register information
- [ ] Add ability to log out
- [ ] Store pictures count in Firebase
- [ ] Retrieve the picture count from Firebase
- [ ] Expose the user id some where in the app
- [ ] Upload receipts to firebase
## WEEK 7 and beyond
- [ ] Must figure out how crafted food names don't get mixed in with the ingredients for the recipe api
  - [ ] Could remove the foods by hand
  - [ ] Run every concept that has a high confidence
  - [ ] Just let it be ignored and take a chance with hoping that a similar concept has the food name and it gets run into the recipe api
  - [ ] Add a point system so that strings that come up a lot are likly ingredients (seems possible)
## Data
- https://data.world/datafiniti/food-ingredient-lists
- https://www.kaggle.com/datafiniti/food-ingredient-lists (same data just a sample size though)
  - The data gives more infomation than neccessary when describing the ingredient. Will need to use one of the string algorithms to determine if they are close to each other.
  - But the thing is that I can run a search through the firebase database becuase it will only give me the childs with the matching key or value.
  - A fix is that I can split all ingredients in the list so that the result is only one word ingredients. So when I add the ingredients to the database I can get ingredients with names such as "mozzarella"
# Tasks
- [X] show a icon to represent sensitive ingredients in food e.g. allergens: nuts, eggs
- [X] Change app icon for rebranding
    - [X] Make sure to use vector image designing
- [X] Remove the list of allergies
    - [X] Make a user dynamic list of search ingredients
- [X] Change app colors for rebranding
- [X] Improve api search in some way
  - [ ] Use google's vision API to detect food in picture
  - [ ] connect to google's vision API
  - [ ] implement allergy check code with google's results
# Future Features
- [ ] Make it so that it can recognize food packages or food bar scanners to get indgredients on food
  - https://www.cloudmersive.com/products
- [X] Fix Memory Issues (NOTE: in the process of fixing)
- [X] Zoom In with camera
- [X] Organize allergies in the setter view (sorts from most recent)
  - Use search bar or sort
- [X] Make a dynamic list of ingredients. (no longer a search bar)
- [X] Have the user add their own allergies
- [ ] Create sub allergens of broad foods
- [X] Log out feature (Maybe won't do) UPDATE: Won't do
- [ ] Make it so that the user doesn't need to enter username and password
# Notes
- [ ] https://firebase.google.com/docs/database/ios/offline-capabilities
- [ ] https://stackoverflow.com/questions/30743408/check-for-internet-connection-with-swift second solution is the best one
- [ ] https://github.com/CocoaPods/CocoaPods/issues/7458#issue-299995441 for merge conflicts with .xcodeproj
- [] https://github.com/CocoaPods/CocoaPods/issues/7835#issuecomment-407428465
- [ ] https://github.com/CocoaPods/CocoaPods/issues/7458#issuecomment-368282154
- [X] Maybe won't add the feature where the app will have additional information about food allergies. Too hard to do ~~and waste of time, energy and effort.~~ and should focus more on the main feature and get that working perfectly.
    - NOTE: well no need for a food allergy information dashboard since the app can no longer contain with any medical advice
- [X] Ready to resubmit to the Appstore. Make sure to run one last test.
    - NOTE: rejected because of non approved medical service.
    - Moving away from being a "medical service" 
    - No longer saying that this app can detect allergies.

