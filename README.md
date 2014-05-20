# Minitest::Parallel::Db

[![Build Status](https://travis-ci.org/ordinaryzelig/minitest-parallel-db.png?branch=master)](https://travis-ci.org/ordinaryzelig/minitest-parallel-db)

Run Minitest in parallel with a single database.

## Rationale

We should be able to run tests in parallel even if there is a database involved.
We can leverage database transactions to keep our tests isolated from each other.

There are solutions out there already, but some require creating multiple databases
or running multiple processes.
Yuck.

## The solution

Tests in parallel must be run in isolation.
If the tests are sharing the same database and table,
we have a problem.
But if we can use a database transaction for each test,
they will be run in isolation from each other (although
write locks are still in effect).

## Usage

```ruby
require 'minitest/parallel/db'
# Set number of threads you want. Best to match your pool size.
# Minitest defaults this to 2.
Minitest::Parallel::Db.concurrency = 10

describe 'your parallel tests' do

  # The tests within this describe block can now be run in parallel.
  include Minitest::Parallel::Db::ActiveRecord

  it 'saves a record' do
    model = Model.create!
    Model.last.id.must_equal model.id
  end

  it 'edits a record' do
    Model.create!
    Model.last.update_attributes(name: 'changed')
    Model.last.name.must_equal 'changed'
  end

end
```

## Requirements

* Postgres (should work with databases that support transactions, but I haven't tried any)
* Minitest >= 4.2 (where `parallelize_me!` exists)
* Supported ORM (ActiveRecord, Sequel)
* Get rid of DatabaseCleaner if you're using it.

### Minitest versions

At the time this gem was created, Minitest was at v4.7.5.
Since then, the way to set the number of concurrent tests to be run has changed.
Please let me know if the version of Minitest you are using doesn't work with this gem so I can try to patch the it.

## Tips

### Use sequences with factories to avoid write blocks on unique fields

If you have a field that is unique (i.e. the database defines it as unique,
not just unique by a model validation), use sequences in your factories.
Unique indexes will be enforced by the database (even if the writes are
in their own transactions), and it will block writes, slowing you down a bit.
To avoid that, use sequences where you can to easily avoid duplicates.

```
factory :users do
  sequence(:username) { |idx| "user #{idx}" }
end
```

## Running tests for this gem

The safe way: run each of the scripts listed in `.travis.yml`.
The quick way: `rake test`.

## Contributing

I have only had the need to implement this with Postgres, ActiveRecord, and Sequel.
I'm sure there is need for more databases like MySQL, and ORMs like Datamapper.
