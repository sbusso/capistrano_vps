Capistrano::Configuration.instance(true).load do
  namespace :redis do

    desc "Install the latest release of Redis"
    task :install, roles: :app do
      run "#{sudo} add-apt-repository -y ppa:chris-lea/redis-server"
      run "#{sudo} apt-get -y update"
      run "#{sudo} apt-get -y install redis-server"
    end
    after "cap_vps:prepare", "redis:install"

    # desc "Setup redis configuration for this application"
    # task :setup, roles: :web do
    #   template "redis.conf.erb", "/tmp/redis.conf"
    #   run "#{sudo} mv /tmp/redis.conf /etc/redis/redis.conf"
    #   restart
    # end
    # after "deploy:setup", "redis:setup"

    %w[start stop restart].each do |command|
      desc "#{command} redis"
      task command, roles: :web do
        run "#{sudo} service redis-server #{command}"
      end
    end

  end
end
