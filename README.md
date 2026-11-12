# Selective demo

A small Rails storefront (orders, pricing, tax, shipping, inventory, loyalty, invoices) with an RSpec suite, wired to [Selective](https://selective.ci) on GitHub Actions.

Each example takes a realistic amount of time (`spec/support/pacing.rb`), so the full suite runs for about a minute across four runners. Set `DEMO_PACE=0` to run it at full speed locally.

## Run a demo

From the **Actions** tab, run **Demo scenario** and pick one:

| Scenario | Change | What you'll see |
|---|---|---|
| `selected` | Gold members earn 4x loyalty points | Only the tests the change can affect run, on one runner |
| `full` | The app moves to Pacific time | The whole suite runs across four runners |

The workflow opens a pull request with the change, and CI runs on it. When you're done, run **Close demo pull requests** to close them all and delete their branches.

## CI

`.github/workflows/ci.yml`:

1. **Plan runners** asks Selective how many runners the change needs (up to 4).
2. **RSpec** starts that many runners, and Selective hands each one tests as it goes.
3. **RSpec** (the gate) passes when every runner passed, whatever the count.

## Local

```bash
bundle install
bin/rails db:schema:load RAILS_ENV=test
DEMO_PACE=0 bundle exec rspec
```
