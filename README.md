# AllergyIndicator
Allergy Indicator is an app that allows users to take pictures of their food and warn them if there are any ingredients in the food that they are allergic to. This app targets people who have food allergies and will try to prevent them from eating the wrong foods. The app will have multiple features that will help indicate the user if there are any allergies in the food they are eating. The main one is to have the user take a picture of the food and using a API the app should prompt the user if there are any allergies. Another addition to the app is that it will have pictures and data of the food the user is allergic to so I user can recognize the foods the user is allergic to. 

# Getting started
If you're a developer hoping to make changes to my code or just wants to play around with it you can run:
```
git clone https://github.com/calee14/FoodAllergyIndicator.git
```
If you want to use the app you can download it on the App Store. [Link will be soon available]().
# Deployment
It should be intuitive enough to open the app in xCode and running it on a simulator.

# Built With
- [Clarifai](https://clarifai.com) - API that recognizes the ingredients in the food
- [Firebase](https://firebase.google.com) - Backend for mobile apps

# Authors
- **Cap Lee** - Pretty much going to be the only contributor

# Todo
- [X] Indicate user that they've taken a photo
  - https://stackoverflow.com/questions/48180635/how-to-insert-image-on-uiview
  - https://stackoverflow.com/questions/28485621/create-uibutton-programmatically-with-constraints-in-swift
- [X] Alert user about allergies in the the food
  - Use table view
- [X] Include recipe API to double check on allergens
  - http://www.recipepuppy.com/about/api/
    - Check the title of the recipe is similar to the classification of the api
    - If they are similar take the ingredients and store them in an array
    - Then check the possible allergens list and check if they match any of the users allergies
    - alert the user
  - https://www.themealdb.com/api.php
- [X] Add UI
  - [X] Color Theme: light blue or green cyan (used both)
- [X] User Dice's Coefficient, which is better than Levenshtein's Distance, to compare strings
- [X] Improve api search algorithm
  - [X] Store ingredients on a databse so we don't search it
  - [X] Update thresholds so that the app will function
- [X] Add disclaimers
- [X] Add disclaimers in the home page when the user first logs in
- [X] Update Terms of Service
- [X] Add more allergens
  - [X] Correct spelling of mustard
  - [X] Remove gutamate
  - [X] Remove colorants
  - [X] Add in all the nuts and sea food
- [X] Add counter for number of pictures (in the home screen page, credits square)
- [X] Add UI for (good . and bad x results)
- [X] Fix the api search (tomatoes)
- [X] Remove email and password authentication (or something like that)
- [X] Change font size so that all of the text can fit in the box
# Future Features
- [ ] Make it so that it can recognize food packages or food bar scanners to get indgredients on food
  - https://www.cloudmersive.com/products
- [ ] Fix Memory Issues
- [X] Zoom In with camera
- [ ] Organize allergies in the setter view
  - Use search bar or sort
- [ ] Have the user add their own allergies
- [ ] Create sub allergens of broad foods
- [ ] Improve api search in some way
- [ ] Log out feature (Maybe won't do)
