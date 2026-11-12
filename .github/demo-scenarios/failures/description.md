Add carrier rate tables for ground, express and freight

Adds published rate tables for three shipping carriers, and tidies the free-shipping check.

**Expect:** Selective runs only the shipping-related tests. Most pass. Three of them are flaky: they fail on a cold cache and pass when Selective retries them, so the build isn't failed by them and they're flagged as flaky. One is a real bug (orders of exactly $75 no longer ship free), which fails on every attempt and fails the build.

_Demo pull request. It will be closed, not merged._
