# Minitest::ParallelDb

Run Minitest in parallel with a database.

## Rationale

There's no reason we can't run tests in parallel even if there is a database involved.
We can leverage database transactions to keep our tests isolated from each other.

There are solutions out there already, but some require creating multiple databases
or running multiple processes.
Yuck.

## The problem and solution

### Short version (lots of jargon and assumptions)

Tests in parallel must be run in isolation.
If the tests are sharing the same database and table,
we have a problem.
But if we can use a database transaction for each test,
they will be run in isolation from each other.

### Long version (less jargon)

Take a look at the following example:

```ruby
describe '2 similar tests' do

  it 'saves a record' do
    model = Model.create!
    Model.first.id.must_equal model.id
  end

  it 'edits a record' do
    Model.create!
    Model.first.update_attributes(name: 'changed')
    Model.first.name.must_equal 'changed'
  end

end
```

Bear with me for a second and ignore the fact that these tests are badly written.
The important thing I want to point out is the problem with running these tests in parallel.
It is entirely possible for the test suite to play out chronologically like this:

order | saves a record                 | edits a record
----- | ------------------------------ | --------------
1 | model = Model.create!              |
2 |                                    | Model.create!
3 |                                    | Model.last.update_attributes(name: 'changed')
4 |                                    | Model.last.name.must_equal 'changed'
5 | Model.last.id.must_equal model.id  |

See the problem in the execution of the code for #5?
`Model.last` will return the model that was created on the right-hand side,
but the test is expecting the model that was created in #1.

This gem aims to solve this problem so that we can have awesome parallel tests.

Some databases like PostgreSQL support these neat little things called transactions.
If you've ever used ActiveRecord, you've already used transactions.
And it's likely you've used it manually for something like this:

```ruby
ActiveRecord::Base.transaction do
  begin
    # Do lots of things in the database that need to work FLAWLESSLY or not at all!
    # ...
  rescue
    # If anything goes wrong, pretend nothing happened,
    # and put the database back to where it was before we started.
    raise ActiveRecord::Rollback
  end
end
```

Database transactions also have another neat feature:
they are only visible to that connection.

Let's do another example to demonstrate:

order | User 1                 | User 2
----- | ---------------------- | ------
1 | model = Model.create!      |
2 |                            | Model.create!
3 | Model.count.must_equal 1   |
4 |                            | Model.count.must_equal 1

By the time #3 is executed, 2 models have been created.
HOWEVER, if each user runs their code within their own transaction,
then the queries performed within those transactions are only visible
to the connection that executed those queries.
That means User 1 can't see the Model that User 2 created (and vice versa)
until the transactions are committed.
If we just ensure that the transaction is rolled back after each test,
then no other test will ever be able to see anything any other test does.
So, given the 2 tests are run in parallel and each is run within a transaction
that will be rolled back,
these tests will pass no matter what order their code is run chronologically.

## Usage

* `require 'minitest-parallel_db'`
* extend appropriate module (e.g. `describe('postgres tests') { extend Minitest::ParallelDb::Postgres }`
* There is no step 3! All your tests are automatically parallel now, and "transaction-safe".

## Requirements

* Postgres
* Minitest >= 4.2 (where `parallelize_me!` exists)
* Supported ORM (ActiveRecord, Sequel)
* Get rid of DatabaseCleaner if you're using it.

## Contributing

I have only had the need to implement this with Postgres, ActiveRecord, and Sequel.
I'm sure there is need for more databases like MySQL, and ORMs like Datamapper.
