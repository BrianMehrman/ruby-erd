require 'rails_helper'

RSpec.describe RubyErd::Generator do
  let(:options) do
    OptionsStruct.new()
  end

  let(:generator) { described_class.new(options) }

  it "has a version number" do
    expect(RubyErd::VERSION).not_to be nil
  end

  describe 'with rails app' do
    let(:options) do
      OptionsStruct.new({
        config_file: 'spec/dummy/config/environment',
        project_dir: 'spec/dummy',
        klasses: ['Bicycle'],
        output: 'test.png'
      })
    end

    it 'creates a visualization' do
      binding.pry
      generator.process
      generator.generate
      generator.print
    end
  end
end
