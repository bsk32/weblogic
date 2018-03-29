require 'spec_helper'
describe 'fmw_opatch' , :type => :class do

  context 'with defaults for all parameters' do
    it { should contain_class('fmw_opatch') }
  end
end
