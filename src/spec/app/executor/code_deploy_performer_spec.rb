RSpec.describe App::Executor::CodeDeployPerformer do
  let(:executor) { described_class.new(event: event, context: context) }
  let(:event) { {} }
  let(:context) { {} }

  it '#execute' do
    expect { executor }.not_to raise_exception
  end
end
