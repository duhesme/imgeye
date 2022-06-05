## Table of Contents
1. [What is this project about?](#about)
2. [Why did I make this project?](#why)
3. [Examples of the app behaviour](#example)
4. [How to run the app](#howto)
<a name="about"></a>
## What is this project about? 
An app for viewing and saving images using the [Unsplash API](https://unsplash.com/documentation).
<a name="why"></a>
## Why did I make this project?
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
<a name="example"></a>
## Examples of the app behaviour
- Main screen (Photo feed).\
![Feed](https://user-images.githubusercontent.com/30961535/171057713-3a67e166-ccc0-4918-ae58-5b932290c7e0.gif)
- Photo Details screen.\
![Details](https://user-images.githubusercontent.com/30961535/171060293-94e7d497-adaa-4df7-8850-af3812034304.gif)
- Adding photo to favorites.\
![Favorites](https://user-images.githubusercontent.com/30961535/171060303-826bc43b-c8df-4dff-8103-ec2f97cf832e.gif)
- Saving photo to Photo Library.\
![Save](https://user-images.githubusercontent.com/30961535/171060310-0d34aab2-1323-421d-a9c4-c40d91f6ffd7.gif)
- Searching by phrase.\
![Search](https://user-images.githubusercontent.com/30961535/171060315-3d58080d-bc3e-4dcb-a3e8-bef9956e2e24.gif)
<a name="howto"></a>
## How to run the app
1. Clone the repo.
2. Open Terminal and navigate to project root folder.
3. Run `pod install && open imgeye.xcworkspace`.
