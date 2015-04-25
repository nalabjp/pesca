DatabaseRewinder.clean_all

class Minitest::Test
  def teardown
    DatabaseRewinder.clean
  end
end