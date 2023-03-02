# RESTKit

![Copy of Sound (819 × 375 px)-2](https://user-images.githubusercontent.com/59176579/222411851-867e5655-aa03-46ff-8ef0-92f6e1de7bc6.png)

RESTKit is a lightweight Swift package for making basic HTTP requests and handling responses. It provides a simple protocol called Request that you can use to define your own HTTP requests (by providing just the necessary parts) and then call it with `send()`

## Installation

You can install RESTKit using the Swift Package Manager. To add RESTKit to your Xcode project, select File > Swift Packages > Add Package Dependency, and enter the following URL:

```swift
https://github.com/your_username/restkit.git
```

## Usage

To use RESTKit in your Swift package, you first need to define a struct or class that conforms to the Request protocol. The Request protocol defines the properties and methods that your request must have, including the URL, HTTP method, headers, and body. You can also define an associated type that specifies the type of the response data that your request expects.

Here's an example of a simple Request implementation that sends a GET request to an API endpoint:

```swift
struct MyRequest: Request {
    typealias RemoteModel = MyResponseModel

    var url: URL? = "https://api.example.com/data"
    var method: HTTPMethod = .get
    var header: [String: String] { ... }
    var body: Data? { ... }
}
```

Once you've defined your Request, you can create an instance of it and call the send() method to send the request and retrieve the response data:

```swift
let request = MyRequest()
let response = await request.send()
```

The send() method returns a Result object that contains the decoded response data or an error.

## Contributing

Contributions are welcome! If you find a bug, have a feature request, or want to contribute code, please open an issue or submit a pull request on GitHub.

## License

RESTKit is released under the MIT license. See LICENSE for details.
