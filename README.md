# cosmos
An example iOS Reddit client with emphasis on testing and automation.

__Requirements:__

CI/CD Server: 

* macOS 10.14
* Xcode 10.1 (Swift 4.2) 
* Simulator w/ iOS 12.1
* Xcode command line tools
* Jenkins 2.15 with JDK 8+

__Idea:__

If a macOS machine with public IP is not available, [Servo](http://serveo.net) is used to publicly expose our Jenkins instance so Github can send webhooks to Jenkins, triggering builds on each pull request. If a macOS machine with public is available, we send Github webhooks directly to that machine. 

__Steps:__

1. Download and install Jenkins for macOS. 
2. Run Jenkins with ```java -jar jenkins.war``` if machine uses JDK 8.
3. Run Jenkins with ```java -jar jenkins.war --enable-future-if``` if machine uses java JDK 10.
4. Configure Github to send webhooks to Jenkins on macOS machine
7. Install and configure Jenkins [Xcode Integration](https://plugins.jenkins.io/xcode-plugin).
8. Attempt Xcode __Source Control > Pull__.
9. Wait for Jenkins + GitHub to do its magic.

__iOS Technologies Involved__

* CoreData 
* Alamofire 
* Kingfisher
* SwiftyJSON

© 2018-2019 William Yang












