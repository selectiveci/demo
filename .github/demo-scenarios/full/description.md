Run the app in Pacific time

An application-wide configuration change: the app's time zone moves from UTC to Pacific time, which can touch anything that reads or stores a time.

**Expect:** Selective runs the entire suite across all four runners, because a change this broad can affect any test.

_Demo pull request. It will be closed, not merged._
