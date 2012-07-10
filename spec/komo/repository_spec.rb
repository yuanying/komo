require 'spec_helper'
require 'fileutils'

describe Komo::Repository do
  let(:all_files) {['Rakefile', 'content/index.html', 'content/archives/2012/07/01/711.html']}

  let(:repository_path) { File.join( $root, 'example' )}
  let(:temp_dir)        { File.join( $root, 'temp', 'example' ) }
  let(:repo)            { Komo::Repository.new(path: repository_path) }
  let(:content_dir)     { File.join( temp_dir, 'content') }

  before  { FileUtils.mkdir_p(temp_dir) }
  after   { FileUtils.rm_rf(temp_dir) }

  describe '#copy_files' do
    let(:index_html)      { File.join( content_dir, 'index.html') }

    it 'copies repository files' do
      pending 'not implemented.'
      lambda {
        repo.copy_files(temp_dir)
      }.should change { File.directory?(content_dir) && File.file?(index_html) }
    end
  end

  describe '#changed_files' do

    context 'when previous_rev = nil' do

      it 'should list all files.' do
        repo.changed_files.sort.should == all_files.sort
      end

    end

  end

end
