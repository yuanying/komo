require 'spec_helper'

describe Komo::WorkingDir do

  context 'when blank directory,' do
    let(:working_dir) { Komo::WorkingDir.new() }

    describe '#revision' do
      it 'should return false.' do

      end

    end

  end

  context 'when already exist revision file,' do

  end

end