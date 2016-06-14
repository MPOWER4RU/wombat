#
# Cookbook Name:: chef-server
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'cheffish'
# there is only zuul
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

config = {
  :chef_server_url => 'https://chef-server',
  :options => {
    :client_name => 'pivotal',
    :signing_key_filename => '/etc/opscode/pivotal.pem',
    :ssl_verify_mode => :verify_none
  }
}

#taken from cheffish
chef_user 'delivery' do
  chef_server config
  admin true
  display_name 'delivery'
  email 'chefeval@chef.io'
  password 'delivery'
  source_key_path '/tmp/private.pem'
end

chef_user 'workstation' do
  chef_server config
  admin true
  display_name 'workstation'
  email 'workstation@chef.io'
  password 'workstation'
  source_key_path '/tmp/private.pem'
end

chef_organization "#{node['demo']['org']}" do
  members ['delivery', 'workstation']
  chef_server config
end

conf_with_org = config.merge({
  :chef_server_url => "#{config[:chef_server_url]}/organizations/#{node['demo']['org']}"
})

build_nodes = []
num = node['demo']['build-nodes']

1.upto(num) do |i|
  build_nodes << "build-node-#{i}"
end

build_nodes.each do |node_name|
  chef_node node_name do
    tag 'delivery-build-node'
    chef_server conf_with_org
  end

  chef_client node_name do
    source_key_path '/tmp/private.pem'
    chef_server conf_with_org
  end
end

chef_acl "" do
  rights :all, user: %w(delivery workstation), clients: build_nodes
  recursive true
  chef_server conf_with_org
end