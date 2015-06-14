# HipagesTwitter: Shows all tweets related to Hipages.

This application searches the T​witter API​ for all tweets related to Hipages and displays it in a tableView  
That includes use of #hashtags, mentions of @hipages, and free form text searches.


### Technology Used 

This application uses Twitters own Fabric framework, TwitterKit framework and TwitterCore framework. It also uses a category on TWTRTweet class.

### Reason of chosen Technology  

The reason behind choosing Twitter provided frameworks is it provides a high level api to work with twitter. It also manages its own background queue for network operations and provide result to main queue when the data arrives. It manages outh protocol and gives TWTRTweetTableViewCell to dispaly the contents. However TWTRTweet (tweet holder class) was not sufficient for my implementation so i created a category on it.   


 
### Run/Installation Instructions

Once you have downloaded the project from the repository select HipagesTwitter.xcodeproj. Then select either simulator or connected device and press Run button. 

 
 