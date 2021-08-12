RSpec.describe App::Executor::RenameWhenTheTime do
  let(:executor) { described_class.new(event: event, context: context) }
  let(:event) { {} }
  let(:context) { {} }
  let(:stub_responses) do
    {
      list_functions: { functions: [{ function_name: 'my-bucket' }] },
    }
  end

  before do
    allow(executor).to receive(:stub_responses).and_return(stub_responses)
  end

  it '#execute' do
    expect { executor.execute }.not_to raise_exception
  end
end
