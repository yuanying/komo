require 'spec_helper'
require 'fileutils'

describe Komo::Repository do

  describe '#copy_files' do
    let(:repository_path) { File.join( $root, 'example' )}
    let(:temp_dir)        { File.join( $root, 'temp', 'example' ) }
    let(:repo)            { Komo::Repository.new(path: repository_path) }
    let(:content_dir)     { File.join( temp_dir, 'content') }
    let(:index_html)      { File.join( content_dir, 'index.html') }

    before  { FileUtils.mkdir_p(temp_dir) }
    after   { FileUtils.rm_rf(temp_dir) }

    it 'copies repository files' do
      pending 'not implemented.'
      lambda {
        repo.copy_files(temp_dir)
      }.should change { File.directory?(content_dir) && File.file?(index_html) }
    end

  end

end
