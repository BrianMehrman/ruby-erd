require 'rails_helper'

RSpec.describe RubyErd::Generator do
  let(:options) do
    OptionsStruct.new()
  end

  let(:generator) { described_class.new(options) }

  it "has a version number" do
    expect(RubyErd::VERSION).not_to be nil
  end

  describe 'with klasses specified' do
    let(:options) do
      OptionsStruct.new({
        config_file: 'spec/dummy/config/environment',
        project_dir: 'spec/dummy',
        klasses: ['Bicycle'],
        output: 'test.png'
      })
    end

    it 'creates a visualization' do
      generator.process
      generator.generate
      generator.print
    end

    describe '#load_project' do
      it 'does not include project dir if already included' do
        $LOAD_PATH.unshift(options.project_dir)
        expect($LOAD_PATH).not_to receive(:unshift)
        generator.send(:load_project)
      end
    end

    describe '#generate' do
      it 'processes the Bicycle class' do
        expect(generator).to receive(:process_class).with(Bicycle).and_call_original
        generator.process
        generator.generate
      end
    end
  end

  describe 'with no klasses specified' do
    let(:options) do
      OptionsStruct.new({
        config_file: 'spec/dummy/config/environment',
        project_dir: 'spec/dummy',
        output: 'test.png'
      })
    end

    it 'processes all classes in the project' do
      generator.process
      generator.generate
      generator.print
    end
  end
end
