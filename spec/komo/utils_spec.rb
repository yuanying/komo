require 'spec_helper'

describe Komo::Utils do

  describe '#to_rel' do
    let(:current) { '/dir_1/dir_2/dir_3' }

    context 'to relative child' do
      it 'should return relative child path.' do
        child = '/dir_1/dir_2/dir_3/dir_4/dir_5/text.txt'
        Komo::Utils.to_rel(current, child).should == 'dir_4/dir_5/text.txt'
      end
    end

    context 'to relative parent' do
      it 'should return relative parent path.' do
        parent = '/dir_1/text.txt'
        Komo::Utils.to_rel(current, parent).should == '../../text.txt'
      end
    end
  end
end