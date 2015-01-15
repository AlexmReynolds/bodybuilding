# bodybuilding
To install first install Cocoa Pods 

sudo gem install cocoapods
cd BodyBuildingDemo
pod install

Open the workspace file to run app.

#things to note
App works in iPhone and iPad.
App supports preferred font size..... 
So if in settings you turn the font size up you will see app resizes to fit it... Mostly
Wrote a few Unit tests

There is one bug. I wanted to use Core Data and an NSFetchResultsController since Daniel did another route.
However I dont have a way to sync up the core data with the server so when sort order changes, I purge all local data.
Problem with this is that it also purges all notes. Since this is a quick app I have not researched any solutions.
