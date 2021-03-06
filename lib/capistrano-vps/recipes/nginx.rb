Capistrano::Configuration.instance(true).load do
  namespace :nginx do
    desc "Install latest stable release of nginx"
    task :install, roles: :web do
      run "#{sudo} add-apt-repository -y ppa:nginx/stable"
      run "#{sudo} apt-get -y update"
      run "#{sudo} apt-get -y install nginx"
    end
    after "cap_vps:prepare", "nginx:install"

    desc "Setup nginx configuration for this application"
    task :setup, roles: :web do
      # send to nginx_conf
      #   http {
      #     server_names_hash_bucket_size 32;
      #   }
      run "#{sudo} rm -f /etc/nginx/sites-enabled/default"
      restart
    end
    after "deploy:setup", "nginx:setup"

    %w[start stop restart].each do |command|
      desc "#{command} nginx"
      task command, roles: :web do
        run "#{sudo} service nginx #{command}"
      end
    end
  end
end
