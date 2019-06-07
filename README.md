# AllergyIndicator
Allergy Indicator is an app that allows users to take pictures of their food and warn them if there are any ingredients in the food that they are allergic to. This app targets people who have food allergies and will try to prevent them from eating the wrong foods. The app will have multiple features that will help indicate the user if there are any allergies in the food they are eating. The main one is to have the user take a picture of the food and using a API the app should prompt the user if there are any allergies. Another addition to the app is that it will have pictures and data of the food the user is allergic to so the user can recognize the foods the user is allergic to. 

# Getting started
If you're a developer hoping to make changes to my code or just wants to play around with it you can type the command below in your terminal:
```
git clone https://github.com/calee14/FoodAllergyIndicator.git
```
If you want to use the app you can download it on the App Store. [Link will be soon available](). May expect some delays due to the long app store review times. 
# Deployment
It should be intuitive enough to open the app in xCode and running it on a simulator.
If you want to use the app you can download it on the App Store. [Link will be soon available](). May expect some delays due to the long app store review times. 
# Built With
- [Clarifai](https://clarifai.com) - API that recognizes the ingredients in the food
- [Firebase](https://firebase.google.com) - Backend for mobile apps
- [Xcode](https://developer.apple.com/xcode/) - IDE for iOS app development
- [RecipePuppy](http://www.recipepuppy.com/about/api/) - API to check ingredients in certain foods

# Authors
- **Cap Lee** - Pretty much going to be the only contributor

# Tasks
- [ ] show a icon to represent sensitive ingredients in food e.g. allergens: nuts, eggs
- [ ] Change app icon for rebranding
    - [ ] Make sure to use vector image designing
- [ ] Remove a list of allergies
    - [ ] Make a user dynamic list of search ingredients
- [ ] Change app colors for rebranding
- [ ] Improve api search in some way
  - [ ] Use google's vision API to detect food in picture
  - [ ] connect to google's vision API
  - [X] check if there is food in image
  - [ ] implement allergy check code with google's results
# Future Features
- [ ] Make it so that it can recognize food packages or food bar scanners to get indgredients on food
  - https://www.cloudmersive.com/products
- [X] Fix Memory Issues
- [X] Zoom In with camera
- [ ] Organize allergies in the setter view
  - Use search bar or sort
- [ ] Make a dynamic list of ingredients to search for.
- [ ] Have the user add their own allergies
- [ ] Create sub allergens of broad foods
- [X] Log out feature (Maybe won't do) UPDATE: Won't do
- [ ] Make it so that the user doesn't need to enter username and password
# Notes
- [X] Maybe won't add the feature where the app will have additional information about food allergies. Too hard to do ~~and waste of time, energy and effort.~~ and should focus more on the main feature and get that working perfectly.
    - NOTE: well no need for a food allergy information dashboard since the app can no longer contain with any medical advice
- [X] Ready to resubmit to the Appstore. Make sure to run one last test.
    - NOTE: rejected because of non approved medical service.
