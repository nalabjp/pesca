require 'test_helper'

class NotificationJobTest < ActiveJob::TestCase
  test 'enqueued' do
    assert_enqueued_jobs 1 do
      NotificationJob.perform_later('test')
    end
  end

  test "#perform with 'events'" do
    job = NotificationJob.new('events')
    job.stub(:notify_events, 'called #notify_events') do
      assert_equal job.perform_now, 'called #notify_events'
    end
  end

  test "#perform with 'exception'" do
    job = NotificationJob.new('exception')
    job.stub(:notify_exception, 'called #notify_exception') do
      assert_equal job.perform_now, 'called #notify_exception'
    end
  end

  test '#notify_events' do
    called_notify = nil
    proc = Proc.new { called_notify = 'called mock proc!' }
    Notifiers::Pushbullet.stub_any_instance(:notify, proc) do
      assert_nil called_notify
      NotificationJob.new.send(:notify_events, [OpenStruct.new])
      assert_equal called_notify, 'called mock proc!'
    end
  end

  test '#notify_exception' do
    called_notify = nil
    proc = Proc.new { called_notify = 'called mock proc!' }
    Notifiers::Pushbullet.stub_any_instance(:notify, proc) do
      assert_nil called_notify
      NotificationJob.new.send(:notify_exception, 'msg1', ['trace1'])
      assert_equal called_notify, 'called mock proc!'
    end
  end
end
