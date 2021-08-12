require 'aws-sdk-s3'
require './lib/app/executor/base'

module App
  module Executor
    class S3TimestampRenamer < Base
      def execute
        bucket_objects.each do |object|
          filename = object.key

          filename.match?(/(.*)\.#{current_str_time}/) do
            dest_filename = Regexp.last_match(1)

            next unless config[:code_deploy_filenames].include?(dest_filename)

            find_second_file_and_rename(dest_filename)
            rename(object, filename, dest_filename)
          end
        end
      end

      private

      def rename(object, source_filename, dest_filename)
        # see: https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Object.html#move_to-instance_method
        object.move_to(bucket: config[:s3_bucket_name], key: dest_filename)

        logger.info(
          {
            message: 'rename',
            bucket_name: config[:s3_bucket_name],
            filename: { source: source_filename, dest: dest_filename },
          },
        )
      end

      def resource
        # see: https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Resource.html
        @resource ||= Aws::S3::Resource.new(region: config[:region])
      end

      def bucket
        # see: https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Resource.html#bucket-instance_method
        @bucket ||= resource.bucket(config[:s3_bucket_name])
      end

      def bucket_objects
        @bucket_objects ||= bucket.objects
      end

      # @return [String] 現在2021-08-01 18:30:00の場合 -> '2021080118'(日本時間)が返却される
      def current_str_time
        @current_str_time ||= Time.now.localtime('+09:00').strftime('%Y%m%d%H')
      end

      def find_second_file_and_rename(filename)
        prefix, suffix = filename.scan(/(.*)\.(.*)/).first

        dest_filename = "#{prefix}_second.#{suffix}"
        source_filename = "#{dest_filename}.new"

        object = find_second_file(source_filename)

        rename(object, source_filename, dest_filename) if object
      end

      def find_second_file(filename)
        bucket_objects.find do |object|
          object.key == filename
        end
      end
    end
  end
end
