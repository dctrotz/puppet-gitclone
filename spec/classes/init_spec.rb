require 'spec_helper'
describe 'gitclone' do

  context 'with defaults for all parameters' do
    it { should contain_class('gitclone') }
  end
end
