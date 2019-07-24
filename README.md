[![Build Status](https://api.travis-ci.com/bkostjens/SGLog.svg?branch=master)](https://travis-ci.org/bkostjens/SGLog)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## SGLog
A Swifty GrayLog Framework, supporting GELF additional fields and offline log queuing out of the box.

#### Compatibility

| SGLog | iOS | Swift
|--|--|--|
| 0.1 | iOS >= 10.1 | Swift 5 |
 
## Installation
### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate SGLog into your Xcode project, specify it in your `Cartfile`:

```ogdl
github "bkostjens/SGLog"
```

### Swift Package Manager

Support for the Swift Package Manager is planned to be added later this year.

## Usage

SGLog needs a [Graylog GELF HTTP input](https://docs.graylog.org/en/3.0/pages/sending_data.html#gelf-via-http) to send the logs to.

Whenever the graylog server is not reachable, logs are queued and stored to disk and are posted the next time a log is send successfully.

SGLog has a couple of  log functions  (one for each syslog level) that can be called after a url is set. The minimum variable that must be provided is the a message string. Optionally a full message can be added, as well as additional fields. 

#### Log functions
 - SGLog.emergency("emergency log message")
 - SGLog.alert("alert log message")
 - SGLog.critical("critical log message")
 - SGLog.error("error log message")
 - SGLog.warning("warning log message")
 - SGLog.notice("notice log message")
 - SGLog.info("info log message")
 - SGLog.debug("debug log message")

#### Full Message

The full message is a string containing more detailed information about the logged message. The example at the bottom shows how these can be used.

#### Additional Field

SGLog supports [GELF additional fields](https://docs.graylog.org/en/3.0/pages/gelf.html#gelf-payload-specification) out of the box.

Allowed characters in field keys are any word character (letter, number, underscore), dashes and dots. The verifying regular expression is: `^[\w\.\-]*$`. Key can not be `'_id'`.

See the example below to see how additional fields can be used with the log functions.

#### Example usage

    // import the SGLog framework
    import SGLog
    
	// Setup SGLog Graylog URL
	SGLog.setURL("https://graylogserver.example.com:12201/gelf")
			
	// Set the host (optional, if not defined it is set to "SGLog")
	SGLog.setHost("myhost.example.com")
	    
	// Create some (optional) additional fields
	let clientAF = AdditionalField(key: "_client", value: "Log test client")
	let clientVersionAF = AdditionalField(key: "_clientVersion", value: "1.0")
	let additionalFields = [clientAF, clientVersionAF]
	
	// Create a message and full_message
	let message = "Test Log Message"
	let fullMessage = "A longer message containing more info about the stuff being logged"
	
	// Send the log to the graylog server
	SGLog.info(message, fullMessage: fullMessage, additionalFields: additionalFields)
	
