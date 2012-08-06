require 'spec_helper'
require 'fileutils'

describe Komo::Repository do
  let(:all_files) {['index.html', 'archives/2012/07/01/711.html']}

  let(:repository_path) { File.join( $root, 'example' )}
  let(:temp_dir)        { File.join( $root, 'temp', 'example' ) }
  let(:repo)            { Komo::Repository.new(path: repository_path) }
  let(:content_dir)     { File.join( temp_dir, 'content') }

  before  { FileUtils.mkdir_p(temp_dir) }
  after   { FileUtils.rm_rf(temp_dir) }

  describe '#modified_files' do

    context 'when previous_rev = nil' do

      it 'should list all files.' do
        repo.modified_files.keys.sort.should == all_files.sort
      end

      it 'should contains Grit::Blob.' do
        repo.modified_files.each do |k, v|
          v.should be_kind_of(Grit::Blob)
        end
      end
    end

  end

  describe '#removed_files' do

    context 'when previous_rev = nil' do

      it 'should return blank array.' do
        repo.removed_files.should == []
      end

    end

  end


end
