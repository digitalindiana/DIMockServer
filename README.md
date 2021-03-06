![Swift](https://img.shields.io/badge/Swift-3.x-4BC51D.svg?style=flat)

DIMockServer
===================

Way to maintain server data for manual and UI tests.

----------

Installation
-----

So far DIMockServer is not included into cocoapod specs.
To use it add following line to your `Podfile`

`pod 'DIMockServer', :git => 'https://github.com/digitalindiana/DIMockServer.git'`

----------

What is DIMockServer?
-----
It's just a very simple framework that helps you to load different `server mock case` to be accessible by your app.

Small presentation on YouTube

https://www.youtube.com/watch?v=6pEwfI2TGUc

Getting started
-----

1. Integrate `DIMockServer` into your app
1. Make sure that `App Transport Security Settings` in `Info.plist` allows `Local Networking` see [FAQ](#faq)
1. Create your base [`MockCase`](#mockcase) 
1. Update your local `API` manager `base URL` to `DIMockServer` url when server is running
> **Note:**  You can check if `DIMockServer` is running by `DIMockServer.isRunning` 

5. Setup name of mock case that you want to run in `Environment Variables`
6. Unleash your **creativity** 🎉  ! 

## MockCase 
-----
> **Note:** Make your subclass of `NSObject` that conforms to `MockCase` protocol
>
>*Why?* Because `DIMockServer` we will able to find and init your `MockCase` class just by using framework.
 
Sample `DemoMockCase`
```
extension MockCase {
    func ticker() throws -> HttpResponse { return HttpResponse.notFound }
    func global() throws -> HttpResponse { return HttpResponse.notFound }
}

class DemoMockCase: NSObject, MockCase {
    var request: HttpRequest?
    
    func ticker() throws -> HttpResponse {
        return self.jsonFileResponse("DefaultTickerResponse")
    }

    func global() throws -> HttpResponse {
        return self.jsonFileResponse("DefaultGlobalResponse")
    }

    func urlMappings() -> URLMappings {
        return ["v1/ticker/?limit=:limit&convert:currency": self.ticker,
                "v1/global": self.global]
    }
}
```

Let's look at this example.

`DemoMockCase` is just class that defines all supported `URLs` by your mock server and give each endpoint default response.

Each new `MockCase` should be subclass of defined by you base Mock Case. 
In that case it should be subclass of `DemoMockCase`

Setting up Environment Variables to test
----
1. Right click on your project
1. `Edit Schema`
1. Add/Edit key `UIMockCaseName` 

![Setting Environment Variables](https://raw.githubusercontent.com/digitalindiana/DIMockServer/master/Resources/enviroment_variable.gif)

You don't have to worry about wrong name of mock case, even if you will fill up `UIMockCaseName` with wrong name, you will be notified about it.

``` 
MockCaseBuilder.swift:20 build(_:baseMockCaseClass:): ❤️MOCK_SERVER: ERROR: Mock case not found: WrongMockCase❤️
 MockCaseBuilder.swift:40 printAvailableMockCases: 💙MOCK_SERVER: Available mock cases:💙
 MockCaseBuilder.swift:41 printAvailableMockCases: 💙DemoMockCase💙
 MockCaseBuilder.swift:44 printAvailableMockCases: 💙DynamicPriceDifferenceMockCase💙
```

How does DIMockServer work?
-----
In order to load your data, we need to setup mock cases and start server. 

* Prepare `MockCases`
    * Create new folder in your project called for example: `MockCases` 
    * Create your [`BaseMockCase`](#mockcase) 
    * In that folder put your `BaseMockCase`  and `SubBaseMockCase` files

* How to start `DIMockServer` ?
1. Open your `AppDelegate` 
1. Add property with `DIMockServer` called for example:
 `var mockServer: DIMockServer?`
1. Create `func` to initalize mocking server
    ```
    func initalizeMockServer() {
        self.mockServer = DIMockServer(baseMockCaseClass: DemoMockCase.self)
        self.mockServer?.start()
    }
    
    ```
1. `start` mock server will take a look into your `Environment Variables` and look for `UIMockCaseName` key, it will automatically create instance of your `MockCase` 

`DIMockServer` is based on [`Swifter`](https://github.com/httpswift/swifter) to handle all HTTP traffic. 

![Setting Environment Variables](https://raw.githubusercontent.com/digitalindiana/DIMockServer/master/Resources/mock_server.png)

You can use any type of response that are available in `Swifter` , look into `HttpResponse` class. 

Sample additions of `DIMockServer` 
- `func jsonFileResponse(_ jsonFile: String, status: Int = 200)`  response from `JSON` file 
- `func jsonStringResponse(_ string: String) `
- `func fileResponse(filename: String, fileExtension: String)` response from any file 

Usage in UI Tests
----
To use `MockCase` in UI Tests you just simple init `XCUIApplication` with extesion

`let app = XCUIApplication.launchApp(with: "DefaultMockCase")`

You can also provide extra parameters to your tests like 

`let app = XCUIApplication.launchApp(with: "DefaultMockCase", parameters: ["-myCustomEnviromentKey","CUSTOM"])`

`DIMockServer` comes with few helper methods for `XCUIApplication` like:
- `pullToRefresh`
- `goToBackground`
- `goToForeground`
- `resetLocationPrivacySettings`

## FAQ
----

How can I allow local networking?
> Please add following in your `Info.plist` file  
```
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsLocalNetworking</key>
        <true/>
    </dict>
```

Simulator is asking me for permission each time I run app, what can I do?

>You can disable firewall for simulator using following commands

```
#temporarily shut firewall off:
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate off
    
#put Xcode as an exception:
/usr/libexec/ApplicationFirewall/socketfilterfw --add /Applications/Xcode.app/Contents/MacOS/Xcode

#put iOS Simulator as an exception:
/usr/libexec/ApplicationFirewall/socketfilterfw --add /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app/Contents/MacOS/Simulator

#re-enable firewall:
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
```

