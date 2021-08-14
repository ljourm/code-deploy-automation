RSpec.describe App::Config do
  let(:dummy_class) { Class.new { include App::Config } }
  let(:dummy_instance) { dummy_class.new }

  describe '#config' do
    subject { dummy_instance.config }

    let(:expected_value) do
      {
        code_deploy: [
          {
            application_name: 'test_20210712',
            group_name: 'blue-green',
            filepath: 'hoge/fuga.zip',
            cloud_front: { distribution_id: 'E1BFT3P6LD2SCL' },
          },
        ],
        log_level: 'FATAL',
        region: 'ap-northeast-1',
        s3_bucket_name: 'code-deploy-automation',
      }
    end

    it { is_expected.to eq(expected_value) }
  end
end
