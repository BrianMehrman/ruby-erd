RSpec.describe RubyErd do
  let(:options) do
    OptionsStruct.new()
  end

  let(:generator) { RubyErd::Generator.new(options) }

  it "has a version number" do
    expect(RubyErd::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end

  describe 'with single file' do
    let(:options) do
      OptionsStruct.new({
        config_file: 'spec/examples/class_02.rb',
        project_dir: 'spec',
        klasses: ['Test'],
        filename: 'test.png'
      })
    end

    it 'creates a visualization' do
      generator.process
      generator.generate
      generator.print
    end
  end
end
