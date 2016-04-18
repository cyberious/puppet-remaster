require 'spec_helper'

describe 'remaster' do
  on_supported_os.each do |os, facts|
    context "OS #{os}" do
      let(:facts) { facts.merge!({:puppet_confdir => '/etc/puppetlabs/puppet'}) }
      let(:params) { {:puppet_master => 'mypuppet_master'} }
      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('remaster') }
        context 'service' do
          describe 'foss' do
            it { is_expected.to contain_service('puppet') }
          end
          describe 'pe' do
            let(:facts) { facts.merge({:is_pe => true}) }
            it { is_expected.to contain_service('pe-puppet') }
          end
        end
        context 'augeas' do
          it { is_expected.to contain_augeas('set_config').with(
              {
                  'incl' => '/etc/puppetlabs/puppet/puppet.conf',
                  'lens' => 'Puppet.lns',
                  'changes' => [
                      'set main/server \'mypuppet_master\''
                  ]
              })
          }
        end
      end
    end
  end
end
