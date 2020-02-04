#
# Cookbook:: mongodb_cookbook_final
# Spec:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'mongod-replica-config::default' do
  context 'When all attributes are default, on Ubuntu 18.04' do
    # for a complete list of available platforms and versions see:
    # https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
    platform 'ubuntu', '18.04'

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'should install MongodDB' do
      expect (chef_run).to install_package 'mongodb'
    end

    it 'should enable mongod service' do
      expect(chef_run).to enable_service 'mongod'
    end

    it 'should start mongod service' do
      expect(chef_run).to start_service 'mongod'
    end


    it 'should create a mongod.conf template in /etc/mongod.conf' do
      expect(chef_run).to create_template('/etc/mongod.conf').with_variables(bind_ip: '0.0.0.0', port: '27017')
    end


    it 'should create a mongod.service template in /lib/systemd/system/mongod.service' do
      expect(chef_run).to create_template '/lib/systemd/system/mongod.service'
    end

    it 'should create a hosts template in /etc/hosts' do
      expect(chef_run).to create_template '/etc/hosts'
    end



    it 'should create a hosts template in /opt/mongo/mongo-keyfile' do
      expect(chef_run).to create_template '/opt/mongo/mongo-keyfile'
    end

end



  # context 'When all attributes are default, on CentOS 7' do
  #   # for a complete list of available platforms and versions see:
  #   # https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
  #   platform 'centos', '7'
  #
  #   it 'converges successfully' do
  #     expect { chef_run }.to_not raise_error
  #   end
  # end
end
