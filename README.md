# OAuth2JSONDataTask
A lightweight networking layer I have been developing for this [personal project](https://vimeo.com/209930522) which has a Django API on the server end. Uses a closure lookup as its core concept, it will never be perfect, features still require implementing and will be pushed much further.

The general approach would be to include a framework but this little project pulls at my desire to learn and discover new and interesting things. Its also in part a response to my growing perception of SOLID principles which took me much too long to discover.

# Installation
Build using Xcode Version 9.2, Swift 4.0

# Configure
There are a small number of simple changes which should enable the project to connect to a server:

sdmAPIConfig.swift
```
// Change host and port settings.
static let Development: String = "0.0.0.0"
static let Default: Int = 8000
```

```
// Modify API endpoint(s).
static let APIRoot: String = "/api/"
static let APIDemo: String = APIRoot + ""

// Modify token endpoint.
static let OAuth2Token: String = "/oauth2/token/"
```

sdmOAuth2Access.swift
```
// Add server application client id and client secret.
static let kClientId: String = ""
static let kClientSecret: String = ""
```

sdmUserAccess.swift
```
// Support identity functions.
func username() -> String?
func password() -> String?
```

# License
Sources are released under the MIT License.
