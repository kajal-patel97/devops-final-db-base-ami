# Policyfile.rb - Describe how you want Chef Infra Client to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile.html

# A name that describes what the system you're building with Chef does.
name 'mongod-replica-config'

# Where to find external cookbooks:
default_source :supermarket
# default_source :github

# run_list: chef-client will run these recipes in the order specified.
run_list 'mongod-replica-config::default'
#run_list 'filebeat::default'

# Specify a custom source for a single cookbook:
cookbook 'mongod-replica-config', path: '.'
#cookbook 'filebeat', path: '../../berks-cookbooks/filebeat'
#cookbook 'filebeat', git: 'https://github.com/kajal-patel97/filebeat-cookbook'
