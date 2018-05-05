# RxBookshelf

[![codebeat badge](https://codebeat.co/badges/b2305a5a-325d-4c40-83f4-e6e605c44ed9)](https://codebeat.co/projects/github-com-emenegro-rx-bookshelf-master)

<img src="etc/rxbookshelf.png" width=200> 

Simple project of a bookshelf to learn Reactive programming in Swift with RxSwift.

<img src="etc/screen4.png" width=190> <img src="etc/screen1.png" width=190> <img src="etc/screen2.png" width=190> <img src="etc/screen3.png" width=190>

# Installation

This project uses Carthage. Run 

`carthage update --configuration Debug --platform iOS` 

to install RxSwift frameworks in debug mode.

# Server

⚠️ In order to work, this app uses another personal project called [bookshelf-server](https://github.com/emenegro/bookshelf-server). Please, refer to the [Installation](https://github.com/emenegro/bookshelf-server#installation) section of project page to get the server up and running.

After that fill the IP of the server in the `Configuration.plist` file as follow:

<img src="etc/config.png" width=400> 

### TODO

- Review memory management because there are RxSwift resources not being correctly disposed.
- Use RxDataSources to improve table view management.
- Testing.

### License

This code is licensed under the [MIT License](LICENSE).
