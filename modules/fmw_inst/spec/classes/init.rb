require 'spec_helper'
describe 'fmw_inst' , :type => :class do

  context 'with defaults for all parameters' do
    it { should contain_class('fmw_inst') }
  end
end
