require 'spec_helper'
describe 'fmw_bsu' , :type => :class do

  context 'with defaults for all parameters' do
    it { should contain_class('fmw_bsu') }
  end
end
