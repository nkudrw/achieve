server '52.192.155.226', user: 'app', roles: %w{app db web}
set :ssh_options, keys: '/home/vagrant/workspace/id_rsa'
