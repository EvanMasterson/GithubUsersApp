# Github Search
Search GitHub users by username, retrieves results from [GitHub API](https://developer.github.com/v3/search/#search-users), results diplayed in a TableViewController where reordering and deletion of cells is in place. Clicking a cell navigates to the DetailViewController where more information is retrieved for the user like follower, following, repository and gist counts.

Implements asynchronous network requests, using Lottie for displaying loading animations as feedback for the user.

Images are cached and loaded asynchronously with SDWebImage

Third Party libraries integerated with [Swift Package Manager](https://swift.org/package-manager/)

## Development Environment
* Xcode 12.0
* Swift 5.3
* iOS 14

### How to Run
```
git clone git@github.com:EvanMasterson/GithubUsersApp.git
open GithubUsers.xcodeproj
Run the application
```

## Third Party Libraries
* [Lottie](https://github.com/airbnb/lottie-ios) - Animations
* [SDWebImage](https://github.com/SDWebImage/SDWebImage) - Image Loading

## Future Features
* Implement authenticated requests to GitHub API to extend the amount of requests allowed in a period of time as GitHub has a low rate limit for unauthenticated requests.
* Add GitHub link to the DetailViewController, for example making the avatar clickable to open web browser directing to the users GitHub page.