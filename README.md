# 🍹 Cocktail Book App 📱

The end goal is to construct an app which will display a list of cocktails provided by the `CocktailsAPI` in the app's Main Screen and details for each of the cocktails in a Details Screen, which is shown whenever one of the cocktails is selected.

<p align="center">
    <img src="MDAssets/overview.png" width="1200" max-width="90%" alt="Design Overview" />
</p>

### Main Screen (initial state)
- Displays a list of the cocktails in an alphabetical order
- Each of the items in the list displays the cocktail name and the cocktail's short description
- UI that will toggle between 3 filter states: all cocktails, alcoholic cocktails and non-alcoholic cocktails. Depending on which filter is selected, the appropriate cocktails will be displayed and the list will be updated. The default filter state will be all cocktails
- It Include a navigation title where the text depends on the state of the filter
- The behavior where tapping on any of the cocktails in the list will present the Details Screen
- Display's the favorite cocktails at the beginning in the list (pinned) respecting the filter state. The favorite and non-favorite section of the list maintains relative alphabetical order

### Details Screen
- Display's a navigation title where the text is the selected cocktail
- Display's an image of the cocktail.
- Display's cocktail's long description
- Display's a list of ingredients (icon and text) that are required for making the cocktail
- Favorite icon toggle button (see the top right corner of the screen in the mocks) which can set the cocktail as "Favorite" or toggle it off for a cocktail that is already "Favorite".

<p align="center">
    <img src="MDAssets/main-screen-with-favorites.png" width="440" max-width="90%" alt="Main screen with favorites" />
</p>

## ❓ Anyone can add updates to this for below

**Provide unit tests & UITests**. Make sure the code is "testable" and provide unit tests for the business logic.

**Persist a list of favorite cocktails**. As of now it's using the UserDefaults can be done with coredata

**Handle errors from the CocktailsAPI**. The API will never fail. However there is an option to initialize the `FakeCocktailsAPI` such that it will fail for couple of times before succeeding.

```swift
let cocktailsAPI: CocktailsAPI = FakeCocktailsAPI(withFailure: .count(3)) 
```
By initializing the object using `withFailure: .count(3)`, all the calls to the API will fail 3 times before succeeding. The only error that the API can fail with is `CocktailsAPIError.unavailable`. When the error occurs make sure to appropriately update the UI and inform the user, with an option to somehow retry to fetch the list of cocktails.

**Extract the CocktailsAPI (contents of CocktailsAPI folder/group) into a separate swift package**. The new package should still belong to the same repository as our app. Keep in mind that some things need to be changed in the CocktailsAPI files, not the behavior itself. The new package should be utilized by the app as a local swift package.

**Free to add additional features/design**. There is no clear goal for this task, it is a way to enrich the app by any means you think are interesting. Sky is the limit :)

## 🤓 Disclaimer

This project was created solely for personal practice and educational purposes. It is not intended for any commercial usage, and its primary purpose is for learning and skill development.

**Copyright Notice:**

The texts and images used in this project are sourced from multiple locations for the purpose of completing assignments and exercises. They should not be shared with others or used in any commercial products. If anyone has copyright concerns or issues with the content used, please contact me via email at [kalikanth007@gmail.com](mailto:kalikanth007@gmail.com) so that I can promptly address and remove the content in question.

Thank you for your understanding.


