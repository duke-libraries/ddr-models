require 'grouper-rest-client'
require "delegate"

module Ddr
  module Auth
    class GrouperGateway < SimpleDelegator

      REPOSITORY_GROUP_FILTER = "duke:library:repository:ddr:"
      SUBJECT_ID_RE = Regexp.new('[^@]+(?=@duke\.edu)')

      def initialize
        super Grouper::Rest::Client::Resource.new(ENV["GROUPER_URL"],
                                                  user: ENV["GROUPER_USER"],
                                                  password: ENV["GROUPER_PASSWORD"],
                                                  timeout: 5)
      end

      # List of all grouper groups for the repository
      def repository_groups
        repo_groups = groups(REPOSITORY_GROUP_FILTER)
        ok? ? repo_groups : []
      end

      def repository_group_names
        repository_groups.collect { |g| g["name"] }
      end

      def user_groups(user)
        groups = []
        subject_id = user.principal_name.scan(SUBJECT_ID_RE).first
        return groups unless subject_id
        begin
          request_body = {
            "WsRestGetGroupsRequest" => {
              "subjectLookups" => [{"subjectIdentifier" => subject_id}]
            }
          }
          # Have to use :call b/c grouper-rest-client :subjects method doesn't support POST
          response = call("subjects", :post, request_body)
          if ok?
            result = response["WsGetGroupsResults"]["results"].first
            # Have to manually filter results b/c Grouper WS version 1.5 does not support filter parameter
            if result && result["wsGroups"]
              groups = result["wsGroups"].select { |g| g["name"] =~ /^#{REPOSITORY_GROUP_FILTER}/ }
            end
          end
        rescue StandardError => e
          Rails.logger.error e
        end
        groups
      end

      def user_group_names(user)
        user_groups(user).collect { |g| g["name"] }
      end

    end
  end
end
