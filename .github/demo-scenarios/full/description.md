Run the specs in random order

A change to how the whole test suite runs: specs now run in a random order each time, to flush out tests that only pass because of what ran before them.

**Expect:** Selective runs the entire suite across all four runners, because a change to the test setup can affect every test.

_Demo pull request. It will be closed, not merged._
