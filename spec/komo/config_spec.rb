require 'spec_helper'

describe Komo::Config do

  let(:config) { Komo::Config.new(File.join($root, 'spec', 'fixtures', 'config.yml')) }

  describe '#site' do
    subject { config.site }
    it { should_not be_nil }

  end

  describe '#deploy' do
    subject { config.deploy }
    it { should_not be_nil }

  end

  describe '#build' do
    subject { config.build }
    it { should_not be_nil }

    describe '#working_dir' do
      subject { config.build.working_dir }
      it 'value should be from config file.' do
        should == '/tmp'
      end
    end

    # describe '#content_dir' do
    #   subject { config.build.content_dir }
    #   it 'should be return absolute path.' do
    #     should == '/tmp/content'
    #   end
    # end
    # 
    # describe '#output_dir' do
    #   subject { config.build.output_dir }
    #   it 'should be return absolute path.' do
    #     should == '/tmp/output'
    #   end
    # end

  end
end