## Table of Contents
1. [What is this project about](#about)
2. [Why did I make this project](#why)
3. [Examples of the app behaviour](#example)
4. [How to run the app](#howto)
## What is this project about <a name="about"></a>
An app for viewing and saving images using the [Unsplash API](https://unsplash.com/documentation).
## Why did I make this project <a name="why"></a>
I made the project to expand my knowledge in iOS Development.\
What I learned from this project:
- How to implement MVVM architecture.
- How to add headers to URLRequest in order to authorize an app in an API.
- How to use URLSession and OperationQueue for downloading progress handling in order to animate loading indicator.
- How to save an image to Photo Library.
- How to use and set up SwiftGen.
- Utilized GCD in order to impore app performance.
- Expanded my knowledge of CoreData (for example,  learned how to save images).
- Expanded my knowlegde of custom UI elements and animations.
## Examples of the app behaviour <a name="example"></a>
- Main screen (Photo feed).\
<img src="https://s8.gifyu.com/images/Feed.gif" width="250" height="485" />
- Photo Details screen.\
<img src="https://s8.gifyu.com/images/Details.gif" width="250" height="485" />
- Adding photo to favorites.\
<img src="https://s8.gifyu.com/images/Favorites.gif" width="250" height="485" />
- Saving photo to Photo Library.\
<img src="https://s8.gifyu.com/images/Save.gif" width="250" height="485" />
- Searching by phrase.\
<img src="https://s8.gifyu.com/images/Searchc21f8d542d80ca32.gif" width="250" height="485" />
## How to run the app <a name="howto"></a>
1. Clone the repo.
2. Open Terminal and navigate to project root folder.
3. Run `pod install && open imgeye.xcworkspace`.