require 'spec_helper'
describe 'fmw_rcu' , :type => :class do

  context 'with defaults for all parameters' do
    it { should contain_class('fmw_rcu') }
  end
end
