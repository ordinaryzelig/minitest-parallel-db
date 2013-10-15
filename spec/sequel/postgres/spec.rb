require_relative 'setup'

describe 'Sequel + Postgres' do

  extend Minitest::ParallelDb::Sequel

  (DB.pool.max_size - 1).times do |idx|
    it "tests in parallel (#{idx + 1})" do
      PSM.new(name: 'name').save

      # Give time for other parallel tests to catch up.
      sleep 1

      # If this is run in transaction,
      # we should only see the model we just created.
      PSM.count.must_equal 1
    end
  end

end
