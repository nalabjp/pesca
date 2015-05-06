require 'test_helper'

class RunnerTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper
  test '#initialize' do
    runner = Runner.new
    assert_equal [], runner.instance_variable_get(:@keywords)
    assert_nil runner.instance_variable_get(:@crawled)
    assert_nil runner.instance_variable_get(:@inserted_ids)
    assert_nil runner.instance_variable_get(:@filtered)
    assert_instance_of Mutex, runner.instance_variable_get(:@mutex)
    assert_equal :prepare, runner.aasm.current_state
  end

  test '#run' do
    runner = Runner.new
    runner.stub(:exec_crawl, true) do
      runner.stub(:exec_import, true) do
        runner.stub(:new_arrival?, true) do
          runner.stub(:exec_filter, true) do
            runner.stub(:find?, true) do
              runner.stub(:exec_notify, true) do
                assert runner.run
              end
            end
          end
        end
      end
    end
    assert_raise Runner::AlreadyRunOnceError do
      runner.run
    end
  end

  test '#exec_crawl' do
    obj = Object.new
    Crawler.stub_any_instance(:crawl, obj) do
      runner = Runner.new
      runner.instance_variable_set(:@providers, Object.new)
      runner.send(:exec_crawl)
      assert_equal obj, runner.instance_variable_get(:@crawled)
    end
  end

  test '#exec_import' do
    Event.stub(:import, {ids: [1,2]}) do
      mock = MiniTest::Mock.new
      mock.expect(:value, 'value')
      runner = Runner.new
      runner.instance_variable_set(:@crawled, [mock])
      runner.send(:exec_import)
      assert_equal [1,2], runner.instance_variable_get(:@inserted_ids)
    end
  end

  test '#exec_fileter' do
    obj = Object.new
    Event.stub(:search_by, [obj]) do
      runner = Runner.new
      runner.send(:exec_filter)
      assert_equal [obj], runner.instance_variable_get(:@filtered)
    end
  end

  test '#exec_notify' do
    assert_enqueued_jobs 1 do
      Runner.new.send(:exec_notify)
    end
  end

  test '#providers' do
    obj = Object.new
    Providers.stub(:instances, [obj]) do
      assert_equal [obj], Runner.new.send(:providers)
    end
  end

  test '#new_arrival?' do
    runner = Runner.new
    refute runner.send(:new_arrival?)
    runner.instance_variable_set(:@inserted_ids, [1,2])
    assert runner.send(:new_arrival?)
  end

  test '#find?' do
    runner = Runner.new
    refute runner.send(:find?)
    runner.instance_variable_set(:@filtered, [Object.new])
    assert runner.send(:find?)
  end

  test '#notify_exception' do
    assert_enqueued_jobs 1 do
      Runner.new.send(:notify_exception, OpenStruct.new)
    end
  end

  test '#log_info' do
    message = nil
    proc = Proc.new {|msg| message = msg}
    Rails.logger.stub(:info, proc) do
      Runner.new.send(:log_info, 'called #log_info')
      assert_equal 'called #log_info', message
    end
  end
end
