module PescaStub
  module Configuration
    def stub_data
      {
        'providers' => %w(zusaar connpass door_keeper),
        'notifiers' => {
          'pushbullet' => {
            'access_token' => 'pushbullet_access_token',
            'targets' => ['iPhone6']
          }
        },
        'filter' => {
          'keywords' => []
        }
      }
    end

    def config_for(name)
      if name.to_s.eql?('pesca')
        stub_data
      else
        super
      end
    end
  end
end

Rails::Application.prepend(PescaStub::Configuration)